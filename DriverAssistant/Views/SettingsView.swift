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
    @AppStorage("metricUnits") var metricUnits = false
    @AppStorage("showSpeed") var showSpeed = true
    var body: some View {
        VStack {
            List {
                Text("Basic settings")
                    .font(.title)
                    .padding(0.5)
                HStack {
                    Toggle(isOn: $visualizeDetections) {
                        Text("Visualize detections")
                        .font(.body)
                    }
                }
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

