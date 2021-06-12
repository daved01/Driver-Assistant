//
//  ImagePickerView.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-06.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var isPresented
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    
    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        Coordinator(picker: self)
    }

    
    // Fetches the images from the camera
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: ImagePicker
        
        init(picker: ImagePicker) {
            self.picker = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            self.picker.image = selectedImage
            self.picker.isPresented.wrappedValue.dismiss()
        }
        
    }

}
