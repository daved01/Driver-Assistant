//
//  PhotoView.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-11.
//

import SwiftUI

struct PhotoView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        VStack {
            image?
            .resizable()
            .scaledToFit()
            
            Button("Select image") {
                self.showImagePicker = true
            }
        }
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
       
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView()
    }
}
