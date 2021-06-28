//
//  Display.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-21.
//

import SwiftUI

struct DisplayView: View {
    @ObservedObject var locationViewModel = LocationViewModel()
    @ObservedObject private var cameraViewModel = CameraViewController()
    
    var body: some View {
            HStack {
                Spacer()
                    VStack {
                        Text("\(Int(locationViewModel.currentSpeed))")
                        .font(.system(size: 82.0))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        Text(locationViewModel.unitString)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                        .font(.system(size: 38.0))
                    Spacer()
                    }
            // Icon
                Spacer()
                VStack {
                    if cameraViewModel.showStopSign == false {
                        
                        Image("stop-sign")
                        .frame(width: 32.0, height: 32.0)
                        .padding(40.0)
                        .accentColor(.red)
                    }
                    else {
                        Spacer()
                    }
                    Spacer()
                }
            }
    }
}

struct Display_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView()
    }
}
