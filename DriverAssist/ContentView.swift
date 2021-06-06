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
            List {
                NavigationLink( destination: LiveView(detect: false)) {
                Text("Start Live View")
                }
                NavigationLink( destination: PreviewView()) {
                    Text("Preview View")
                }
                NavigationLink( destination: LibraryView()) {
                    Text("Test with image")
                }
            }
        }
        .navigationTitle("Driver Assist")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
