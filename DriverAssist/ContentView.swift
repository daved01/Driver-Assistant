//
//  ContentView.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-05.
//

import SwiftUI

struct ContentView: View {
    let elementColour = Color(.red)
    @State private var isHidden: Bool = true
    
    var body: some View {
        NavigationView {
        VStack {
            CameraViewController()
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
            if !isHidden {
            HStack {
                Spacer()
                NavigationLink(destination: LibraryView()) {
                    VStack {
                        Image("sharp_video_library_black_24pt")
                        .foregroundColor(elementColour)
                        Text("Library")
                        .font(.caption)
                        .foregroundColor(elementColour)
                        }
                    }
                    Spacer()
                    NavigationLink(destination: PhotoView()) {
                    VStack {
                        Image("baseline_photo_camera_black_24pt")
                        .foregroundColor(elementColour)
                        Text("Image mode")
                        .font(.caption)
                        .foregroundColor(elementColour)
                        }
                    }
                    Spacer()
                    NavigationLink(destination: Settings()) {
                    VStack {
                        Image("baseline_settings_black_24pt")
                        .foregroundColor(elementColour)
                        Text("Settings")
                        .font(.caption)
                        .foregroundColor(elementColour)
                        }
                    }
                    Spacer()
                    }
                }
            }
            .gesture(TapGesture()
            .onEnded{ isHidden.toggle()})
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
