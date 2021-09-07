//
//  SettingsView.swift
//  DriverAssistant
//
//  Created by David Kirchhoff on 2021-06-10.
//

import SwiftUI

struct Settings: View {
    @State private var shareData = false
    @AppStorage("visualizeDetections") var visualizeDetections = true
    @AppStorage("showLabels") var showLabels = true
    @AppStorage("metricUnits") var metricUnits = false
    @AppStorage("showSpeed") var showSpeed = true
    @AppStorage("iouThreshold") var iouThreshold = 0.6
    @AppStorage("confidenceThreshold") var confidenceThreshold = 0.45
    var body: some View {
        VStack {
            List {
                Text("Basic settings")
                    .font(.title)
                    .padding(0.5)
                HStack(alignment: .center) {
                    Toggle(isOn: $showSpeed) {
                        Text("Show speed")
                        .font(.body)
                    }
                }
                HStack(alignment: .center) {
                    Toggle(isOn: $metricUnits) {
                        Text("Use metric units")
                        .font(.body)
                    }
                }
                
                Text("Detector settings")
                    .font(.title)
                    .padding(0.5)
                HStack {
                    Toggle(isOn: $visualizeDetections) {
                        Text("Show bounding boxes")
                        .font(.body)
                    }
                }
                HStack {
                    Toggle(isOn: $showLabels) {
                        Text("Show labels")
                        .font(.body)
                    }
                }
                
                VStack {
                    Slider(value: $iouThreshold, in: 0...1)
                    Text("IoU threshold")
                        .font(.body)
                }
                VStack {
                    Slider(value: $confidenceThreshold, in: 0...1)
                        Text("Confidence threshold")
                        .font(.body)
                }
                
                Text("Further")
                    .font(.title)
                    .padding(0.5)
                NavigationLink(destination: WebView()) {
                Text("Learn how detection works")
                    .font(.body)
                }
                

            }

        }
        .navigationBarTitle("Settings")
    }
        
        
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}

