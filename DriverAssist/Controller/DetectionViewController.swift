//
//  DetectionViewController.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-27.
//

import Foundation
import UIKit
import AVKit
import SwiftUI
import Vision

// TODO: Need to move this to the CameraViewController stuff!!!
final class DetectionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    //@Published var firstLabel: String = "Init - banana??"
    private var firstLabel: String = ""
    
    
    var bufferSize: CGSize = .zero
    //private let videoDataOutput = AVCaptureVideoDataOutput()
    //private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Start camera
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.sessionPreset = .vga640x480 // For detection
        captureSession.addInput(input)
        


        captureSession.startRunning()
        
        
        
        
        
        // Show the ouput
        let previewLayer  = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
                
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        
        
        
        let captureConnection = dataOutput.connection(with: .video)
        
        // Always process the frames
        captureConnection?.isEnabled = true
        do {
            try  captureDevice.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((captureDevice.activeFormat.formatDescription))
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            captureDevice.unlockForConfiguration()
        } catch {
            print(error)
        }
        print(bufferSize.width)
        print(bufferSize.height)
        
        
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("Camera was able to capture a frame:", Date())
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: ObjectDetector().model) else { return }
        
    
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            //perhaps check the err
            
            //print(finishedReq.results)
            
            guard let results = finishedReq.results as? [VNDetectedObjectObservation] else { return }
            
            //guard let firstObservation = results.first else { return }
                       
            DispatchQueue.main.async {
                //self.drawResults([results])
                if let results = finishedReq.results {
                    self.drawResults(results)
                }
            }
            
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])

    }
    
    
    func drawResults(_ results: [Any]) {
        print("\n-----")
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            
            
            // Select only the label with the highest confidence. Return list later!
            let topLabelObservation = objectObservation.labels[0]
            print(topLabelObservation.identifier)
            print(topLabelObservation.confidence)
            print(objectObservation.boundingBox)
            
            firstLabel = topLabelObservation.identifier
            //let bboxArray = objectObservation.boundingBox
            
            
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            print(objectBounds)
        
            
           
            
            //-------TEST--------
            
            
            
            // Make label text
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = firstLabel
            self.view.addSubview(label)
            
            
            
            // Make a bounding box
            //let box: CGRect = objectBounds
            //let boxView = UIView(frame: box)
            //boxView.backgroundColor = UIColor.green
            //self.view.addSubview(boxView)
            //detectionOverlay.addSublayer(label)
            let shapeLayer = CALayer()
            shapeLayer.bounds = objectBounds
            shapeLayer.position = CGPoint(x: objectBounds.midX, y: objectBounds.midY)
            shapeLayer.name = "Found Object"
            shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
            shapeLayer.cornerRadius = 7
            //self.view.layer.insertSublayer(shapeLayer, above: )
            
            
            
            
            
            //-------TEST--------
            
            
            
            
            //self.firstLabel = "Updated"
            
            //let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            
            //let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
            /*
            let textLayer = self.createTextSubLayerInBounds(objectBounds,
                                                            identifier: topLabelObservation.identifier,
                                                            confidence: topLabelObservation.confidence)
            shapeLayer.addSublayer(textLayer)
            detectionOverlay.addSublayer(shapeLayer)
             */
        }
    }
}


extension DetectionViewController: UIViewControllerRepresentable {
    public typealias UIViewControllerType = DetectionViewController
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<DetectionViewController>) -> DetectionViewController {
        return DetectionViewController()
    }

    public func updateUIViewController(_ uiViewController: DetectionViewController, context: UIViewControllerRepresentableContext<DetectionViewController>) {
    }
}
