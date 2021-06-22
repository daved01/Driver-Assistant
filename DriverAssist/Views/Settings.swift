//
//  Settings.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-10.
//

import SwiftUI

struct Settings: View {
    @State private var useModel = false
    @State private var alwaysRecord = false
    @State private var shareData = false
    
    var body: some View {
        List {
            HStack {
                Toggle(isOn: $useModel) {
                    Text("Use model")
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
                Toggle(isOn: $shareData) {
                    Text("Units imperial/metric")
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
