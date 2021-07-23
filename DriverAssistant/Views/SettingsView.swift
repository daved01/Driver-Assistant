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
        List {
            HStack {
                Toggle(isOn: $visualizeDetections) {
                    Text("Visualize detections")
                    .font(.body)
                }
            }
            HStack(alignment: .center) {
                Toggle(isOn: $showSpeed) {
                    Text("Show speed")

                Toggle(isOn: $metricUnits) {
                    Text("Use metric units")

                    .font(.body)
                }
                
            }

        }
        .navigationBarTitle("Settings")
    }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}

