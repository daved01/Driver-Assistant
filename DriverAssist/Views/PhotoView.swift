//
//  PhotoView.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-11.
//

import SwiftUI

struct PhotoView: View {
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    var body: some View {
        VStack {
            Spacer()
            Image("testimage")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            Spacer()
            Button("Select image") {
            self.sourceType = .photoLibrary
            self.isImagePickerDisplay.toggle()
            }
            
            
            .padding()
            .foregroundColor(.white)
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/)
            .cornerRadius(30.0)
            .sheet(isPresented: self.$isImagePickerDisplay) {
                    ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
            }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView()
    }
}
