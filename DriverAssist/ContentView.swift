//
//  ContentView.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Text("Example 1")
                    Text("Example 2")
                    Text("Example 3")
                }
            HStack {
                Spacer()
                NavigationLink(destination: LibraryView()) {Image("baseline_photo_camera_black_36pt")}
                Spacer()
                NavigationLink(destination: LiveView()) {Image("baseline_videocam_black_36pt")}
                Spacer()
                NavigationLink(destination: Settings()) {Image("baseline_settings_black_36pt")}
                Spacer()
                }
            }
            .navigationTitle("Library")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
