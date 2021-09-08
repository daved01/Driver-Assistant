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
    private var firstConfidence: Float = 0.0
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
        detectionOverlay.sublayers = nil // Remove all the old recognized objects
        
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
            firstConfidence = topLabelObservation.confidence
            
            // TODO: Scale boxes
            // bufferSize.width: 1920, bufferSize.height: 1080
            // objectObservation.boundingBox is a normalized rectangle.
            // objectObservation.boundingBox has origin at lower left of the image and normalized coordinates to the processed image.
            // It is a CGRect.
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            
            // Visualize results if selected in settings
            let visualizeDetections = UserDefaults.standard.bool(forKey: "visualizeDetections")
            let showLabels = UserDefaults.standard.bool(forKey: "showLabels")
           
            if visualizeDetections == true {
                let boxLayer = self.drawBoxes(objectBounds, label: firstLabel)
                detectionOverlay.addSublayer(boxLayer)
            }
            if showLabels == true {
                let labelLayer = self.drawLabels(objectBounds, label: firstLabel, confidence: firstConfidence)
                detectionOverlay.addSublayer(labelLayer)
            }
            
            let iconLayer = self.showIndicators(label: firstLabel)
            detectionOverlay.addSublayer(iconLayer)
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
        detectionOverlay.bounds = CGRect(x: 0.0, y: 0.0, width: bufferSize.width, height: bufferSize.height)
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
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(0.0)).scaledBy(x: scale, y: -scale))
        // Centre layer
        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
        CATransaction.commit()
    }
    
    
    func drawLabels(_ bounds: CGRect, label: String, confidence: VNConfidence) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        
        // Format the string
        let font = UIFont.systemFont(ofSize: 30)
        var colour = Constants.TextColours.light
        
        // Place the labels
        let labelHeight: CGFloat = 40.0
        let yPosOffset: CGFloat = 18.0
        
        if label == "traffic_light_red" {
            textLayer.backgroundColor = Constants.BoxColours.trafficRed
        }
        else if label == "traffic_light_green" {
            textLayer.backgroundColor = Constants.BoxColours.trafficGreen
            colour = Constants.TextColours.dark
        }
        else if label == "traffic_light_na" {
            textLayer.backgroundColor = Constants.BoxColours.trafficNa
            colour = Constants.TextColours.dark
        }
        else if label == "stop sign" {
            textLayer.backgroundColor = Constants.BoxColours.trafficRed
        }
        else if label == "bicycle" || label == "person" {
            textLayer.backgroundColor = Constants.BoxColours.pedestrian
        }
        else {
            textLayer.backgroundColor = Constants.BoxColours.misc
        }
        
        let attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: colour] as [NSAttributedString.Key : Any]
        let formattedString = NSMutableAttributedString(string: String(format: "\(label) (%.2f)", confidence), attributes: attribute)
        textLayer.string = formattedString
        
        let boxWidth: CGFloat = CGFloat(formattedString.length * 13)
        textLayer.bounds = CGRect(x: 0, y: 0, width: boxWidth, height: labelHeight)
        textLayer.position = CGPoint(x: bounds.minX+(boxWidth/2.0), y: bounds.maxY+yPosOffset)
        
        textLayer.foregroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(0)).scaledBy(x: 1.0, y: -1.0))
        return textLayer
    }
    
    
    // Displays the icons for traffic lights and stop sign in the top right
    func showIndicators(label: String) -> CAShapeLayer {
        let signLayer = CAShapeLayer()
        if label == "traffic_light_red" {
            trafficLightRed.isHidden = false
            trafficLightGreen.isHidden = true
            stopSign.isHidden = true
        }
        else if label == "traffic_light_green" {
            trafficLightRed.isHidden = true
            trafficLightGreen.isHidden = false
            stopSign.isHidden = true
        }
        else if label == "traffic_light_na" {
            trafficLightRed.isHidden = true
            trafficLightGreen.isHidden = true
            stopSign.isHidden = true
        }
        else if label == "stop sign" {
            trafficLightRed.isHidden = true
            trafficLightGreen.isHidden = true
            stopSign.isHidden = false
        }
        return signLayer
    }
    
    
    // Returns CAShapeLayer with box. Draws box around centre with dimensions specified in CRect: objectBounds.
    func drawBoxes(_ objectBounds: CGRect, label: String) -> CAShapeLayer {
        let boxLayer = CAShapeLayer()
        boxLayer.bounds = objectBounds
        boxLayer.position = CGPoint(x: objectBounds.midX, y: objectBounds.midY)

        boxLayer.cornerRadius = 4.0
        boxLayer.borderWidth = 6.0
        // Box colour depending on label
        // Hierachy: Red > Green > stop sign
        if label == "traffic_light_red" || label == "stop sign" {
            boxLayer.borderColor = Constants.BoxColours.trafficRed
            boxLayer.borderWidth = 12.0
        }
        else if label == "traffic_light_green" {
            boxLayer.borderColor = Constants.BoxColours.trafficGreen
            boxLayer.borderWidth = 10.0
        }
        else if label == "traffic_light_na" {
            boxLayer.borderColor = Constants.BoxColours.trafficNa
            boxLayer.borderWidth = 10.0
        }
        else if label == "person" || label == "bicycle" {
            boxLayer.borderColor = Constants.BoxColours.pedestrian
            boxLayer.borderWidth = 10.0
        }
       
        else {
            boxLayer.borderColor = Constants.BoxColours.misc
        }
        return boxLayer
    }
}
