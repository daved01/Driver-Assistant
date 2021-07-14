//
//  SettingsView.swift
//  DriverAssistant
//
//  Created by David Kirchhoff on 2021-06-10.
//

import SwiftUI

struct Settings: View {
    @State private var alwaysRecord = false
    @State private var shareData = false
    @AppStorage("visualizeDetections") var visualizeDetections = true
    @AppStorage("metricUnits") var metricUnits = false
    
    var body: some View {
        List {
            HStack {
                Toggle(isOn: $visualizeDetections) {
                    Text("Visualize detections")
                    .font(.body)
                }
            }
            HStack(alignment: .center) {
                Toggle(isOn: $alwaysRecord) {
                    Text("Always record")
                    .font(.body)
                }
            }
            HStack(alignment: .center) {
                Toggle(isOn: $shareData) {
                    Text("Share data")
                    .font(.body)
                }
            }
            HStack(alignment: .center) {
                Toggle(isOn: $metricUnits) {
                    Text("Use metric units")
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

