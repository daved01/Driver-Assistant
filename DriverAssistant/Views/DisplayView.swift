//
//  DisplayView.swift
//  DriverAssistant
//
//  Created by David Kirchhoff on 2021-06-21.
//

import SwiftUI

struct DisplayView: View {
    @ObservedObject var locationViewModel = LocationViewModel()
    //@ObservedObject var visionObjectRecognitionViewController = VisionObjectRecognitionViewController()
    
    var body: some View {
            HStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                    VStack {
                        Text("\(Int(locationViewModel.currentSpeed))")
                        .font(.system(size: 82.0))
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        Text(locationViewModel.unitString)
                        .foregroundColor(.black)
                        .fontWeight(.light)
                        .font(.system(size: 38.0))
                    Spacer()
                    }
                Spacer()
                // Icon
                VStack {
                    Image("stop-sign")
                    .frame(width: 32.0, height: 32.0)
                    .padding(40.0)
                    .accentColor(.red)
                        //.opacity(visionObjectRecognitionViewController.showStopSign ? 1: 0)
                    Spacer()
                }
            }
            .navigationBarHidden(true)
    }
}

struct Display_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView()
    }
}

