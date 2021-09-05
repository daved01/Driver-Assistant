//
//  VisionObjectRecongnitionViewController.swift
//  DriverAssistant
//
//  Created by David Kirchhoff on 2021-06-21.
//

import UIKit
import AVFoundation
import Vision

class VisionObjectRecognitionViewController: ViewController, ObservableObject {
    
    @Published var showStopSign: Bool = false
    private var detectionOverlay: CALayer! = nil
    private var firstLabel: String = ""
    
    // Vision parts
    private var requests = [VNRequest]()
    
    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "yolov5sTrafficTest", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file not found!"])
        }
        
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            
            // Adjust iouThreshold and confidenceThreshold here.
            visionModel.inputImageFeatureName = "iouThreshold"
            visionModel.inputImageFeatureName = "confidenceThreshold"
            visionModel.inputImageFeatureName = "image"
            
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    
                    if let results = request.results {
                        self.drawVisionRequestResults(results)
                    }
                })
            })
            //objectRecognition.imageCropAndScaleOption = .scaleFill // Aspect ratio of input.
            
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading failed: \(error)")
        }
        
        return error
    }
    
    func drawVisionRequestResults(_ results: [Any]) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil // remove all the old recognized objects
        
        // Remove
        trafficLightRed.isHidden = true
        trafficLightGreen.isHidden = true
        stopSign.isHidden = true
        
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            
            
            
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            firstLabel = topLabelObservation.identifier
            
            // TODO: Scale boxes
            // bufferSize.width: 1920, bufferSize.height: 1080
            // objectObservation.boundingBox is a normalized rectangle.
            // objectObservation.boundingBox has origin at lower left of the image and normalized coordinates to the processed image.
            // It is a CGRect.
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            
            // Visualize results if selected in settings
            let visualizeDetections = UserDefaults.standard.bool(forKey: "visualizeDetections")
            if visualizeDetections == true {
                let shapeLayer = self.drawBoxes(objectBounds, label: firstLabel)
                //let textLayer = self.drawLabels(objectBounds, identifier: topLabelObservation.identifier,confidence: topLabelObservation.confidence)
                //shapeLayer.addSublayer(textLayer)
                detectionOverlay.addSublayer(shapeLayer)
            }
        }
        self.updateLayerGeometry()
        CATransaction.commit()
    }
    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        // Set orientation of devive.
        let exifOrientation = exifOrientationFromDeviceOrientation()
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    override func setupAVCapture() {
        super.setupAVCapture()
        
        // setup Vision parts
        setupLayers()
        updateLayerGeometry()
        setupVision()
        
        // start the capture
        startCaptureSession()
    }
    
    func setupLayers() {
        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0.0,
                                         y: 0.0,
                                         width: bufferSize.width,
                                         height: bufferSize.height)
        detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
        rootLayer.addSublayer(detectionOverlay)
    }
    
    func updateLayerGeometry() {
        let bounds = rootLayer.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / bufferSize.width
        let yScale: CGFloat = bounds.size.height / bufferSize.height
        
        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        // Rotate the layer into screen orientation and scale and mirror
        // Change the quotient to 1.0 for portrait
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(0.0)).scaledBy(x: scale, y: -scale)) // .pi / 2.0
        // Center the layer
        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
        CATransaction.commit()
    }
    
    func drawLabels(_ bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)\nConfidence:  %.2f", confidence))
        let largeFont = UIFont(name: "Helvetica", size: 24.0)!
        formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: identifier.count))
        textLayer.string = formattedString
        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        textLayer.shadowOpacity = 0.7
        textLayer.shadowOffset = CGSize(width: 2, height: 2)
        textLayer.foregroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])
        textLayer.contentsScale = 2.0 // retina rendering
        // rotate the layer into screen orientation and scale and mirror
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
        return textLayer
    }
    
    // Returns CAShapeLayer with box. Draws box around centre with dimensions specified in CRect: objectBounds.
    func drawBoxes(_ objectBounds: CGRect, label: String) -> CAShapeLayer {
        let boxLayer = CAShapeLayer()
        boxLayer.bounds = objectBounds
        boxLayer.position = CGPoint(x: objectBounds.midX, y: objectBounds.midY)

        boxLayer.cornerRadius = 6.0
        boxLayer.borderWidth = 8.0
        // Box colour depending on label
        // Hierachy: Red > Green > stop sign
        if label == "traffic_light_red" {
            boxLayer.borderColor = CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            trafficLightRed.isHidden = false
            trafficLightGreen.isHidden = true
            stopSign.isHidden = true
            boxLayer.borderWidth = 14.0
        }
        else if label == "traffic_light_green" {
            boxLayer.borderColor = CGColor.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
            trafficLightRed.isHidden = true
            trafficLightGreen.isHidden = false
            stopSign.isHidden = true
            boxLayer.borderWidth = 12.0
        }
        else if label == "traffic_light_na" {
            boxLayer.borderColor = CGColor.init(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
            trafficLightRed.isHidden = true
            trafficLightGreen.isHidden = true
            stopSign.isHidden = true
            boxLayer.borderWidth = 12.0
        }
        else if label == "stop sign" {
            boxLayer.borderColor = CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            trafficLightRed.isHidden = true
            trafficLightGreen.isHidden = true
            stopSign.isHidden = false
            boxLayer.borderWidth = 14.0
        }
        else {
            boxLayer.borderColor = CGColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        }

        
        return boxLayer
    }
    
}

