//
//  Detector.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-10.
//

import UIKit

class ObjectDetector {
   /* lazy var module: InferenceModule = {
        if let filePath = Bundle.main.path(forResource: "yolov5s.torchscript", ofType: "pt"),
            let module = InferenceModule(fileAtPath: filePath) {
            return module
        } else {
            fatalError("Failed to load model!")
        }
    }()
    */
    lazy var classes: [String] = {
        if let filePath = Bundle.main.path(forResource: "classes", ofType: "txt"),
            let classes = try? String(contentsOfFile: filePath) {
            return classes.components(separatedBy: .newlines)
        } else {
            fatalError("classes file was not found.")
        }
    }()
}
