//
//  PreviewView.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-06.
//

import SwiftUI

struct PreviewView: View {
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .bottom){
                       Button("Camera") {
                           self.sourceType = .camera
                           self.isImagePickerDisplay.toggle()
                       }
                       .padding()
                       .foregroundColor(.white)
                       .background(Color.accentColor)
                       .cornerRadius(10.0)
                       Spacer()
                       Button("Photo Library") {
                           self.sourceType = .photoLibrary
                           self.isImagePickerDisplay.toggle()
                       }
                       .padding()
                       .foregroundColor(.white)
                       .background(Color.accentColor)
                       .cornerRadius(10.0)
                }
                .padding()
            }
            .navigationBarTitle("Live Preview")
            .sheet(isPresented: self.$isImagePickerDisplay) {
                    ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                   }
                   
               }
    }
}

struct PreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
    }
}
