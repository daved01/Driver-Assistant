//
//  LibraryView.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-06.
//

import SwiftUI

struct LibraryView: View {
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    var body: some View {
        Button("Photo Library") {
            self.sourceType = .photoLibrary
            self.isImagePickerDisplay.toggle()
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
