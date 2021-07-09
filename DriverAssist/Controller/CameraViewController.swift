//
//  CameraViewController.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-11.
//

import Foundation
import UIKit
import AVKit
import SwiftUI
import Vision


// UIViewController - Used to bring views to live
final class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    @Published var showStopSign = false
    
    private var previewView: UIView!
    private var firstLabel: String = ""
    private var bufferSize: CGSize = .zero
    private let detectionLayer = CALayer()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    
    override func viewDidLoad() {
        
        previewView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(previewView)
        
        // Prepare
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.sessionPreset = .vga640x480 // For detection
        captureSession.addInput(input)
        captureSession.startRunning()
                
        // Display
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        // Adds full screen view
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = .landscapeRight
               
        do {
            try  captureDevice.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((captureDevice.activeFormat.formatDescription))
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            captureDevice.unlockForConfiguration()
        } catch {
            print(error)
        }
        
        // TODO: DetectionLayer is not as wide as the video output. Is that a problem??????
        //detectionLayer.backgroundColor = CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        detectionLayer.bounds = CGRect(x: 0.0,
                                         y: 0.0,
                                         width: bufferSize.width,
                                         height: bufferSize.height)
        detectionLayer.position = CGPoint(x: previewLayer.bounds.midX, y: previewLayer.bounds.midY)
        previewLayer.addSublayer(detectionLayer)
        
        // Add video preview stream (UIView layer) in previewLayer
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        

        // Update geometry
        let bounds = previewLayer.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / bufferSize.height
        let yScale: CGFloat = bounds.size.height / bufferSize.width
        
        print(xScale)
        print(yScale)
        
        
        
        
        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        // rotate the layer into screen orientation and scale and mirror
        detectionLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(0.0)).scaledBy(x: scale, y: scale))
        // center the layer
        detectionLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        CATransaction.commit()
        
        
        //aaaaaaaa
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        let captureConnection = dataOutput.connection(with: .video)
        
        // Always process the frames
        captureConnection?.isEnabled = true
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Load model
        //let model2 = yolov5sTraffic()
        guard let model = try? VNCoreMLModel(for: YOLOv3TinyFP16(configuration: .init()).model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            //guard let results = finishedReq.results as? [VNDetectedObjectObservation] else { return }
            //guard let firstObservation = results.first else { return }
            DispatchQueue.main.async {
                if let results = finishedReq.results {
                    self.drawResults(results)
                }
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func drawResults(_ results: [Any]) {
        detectionLayer.sublayers = nil // Clear previous detections from the detectionlayer
    
        for observation in results where observation is VNRecognizedObjectObservation {
            
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            
            // Select only the label with the highest confidence. Return list later!
            let topLabelObservation = objectObservation.labels[0]
            firstLabel = topLabelObservation.identifier
            
            // Get coordinates for bounding box
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            
            // Visualize detections if selected
            let visualizeDetections = UserDefaults.standard.bool(forKey: "visualizeDetections")
            if visualizeDetections == true {
                // Make label
                let labelLayer = drawLabel(objectBounds: objectBounds, label: firstLabel)
                detectionLayer.addSublayer(labelLayer)
            
                // Make bounding box
                let boxLayer = drawBox(objectBounds: objectBounds, label: firstLabel)
                detectionLayer.addSublayer(boxLayer)
                
                // Add the detection layer to the view. Will be cleared for the next detection.
                view.layer.addSublayer(detectionLayer)
            }
        }
        
        // Place the label on top of the box
        func drawLabel(objectBounds: CGRect, label: String ) -> CATextLayer {
            let labelLayer = CATextLayer()
            //labelLayer.frame = CGRect(x: objectBounds.midX, y: objectBounds.midY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
            labelLayer.bounds = CGRect(x: 0, y: 0, width: objectBounds.size.height - 10, height: objectBounds.size.width - 10)
            labelLayer.position = CGPoint(x: objectBounds.midX, y: objectBounds.midY)
            labelLayer.fontSize = 10
            labelLayer.alignmentMode = .left
            labelLayer.string = label
            labelLayer.truncationMode = .end
            labelLayer.foregroundColor = UIColor.black.cgColor
            return labelLayer
        }
        
        // Draw the box
        func drawBox(objectBounds: CGRect, label: String) -> CAShapeLayer {
            let boxLayer = CAShapeLayer()
            boxLayer.bounds = objectBounds
            boxLayer.position = CGPoint(x: objectBounds.midX, y: objectBounds.midY)
            boxLayer.cornerRadius = 10.0
            
            // Box colour depending on label
            if label == "Banana" {
                boxLayer.borderColor = CGColor.init(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.5)
                self.showStopSign = true
            }
            else {
                boxLayer.borderColor = CGColor.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
                self.showStopSign = false
            }
            
            boxLayer.borderWidth = 3.0
            return boxLayer
        }
    }
}


// UIViewControllerRepresentable
extension CameraViewController : UIViewControllerRepresentable {
    public typealias UIViewControllerType = CameraViewController
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> CameraViewController {
        return CameraViewController()
    }
    
    public func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraViewController>) {
    }
}
