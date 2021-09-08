//
//  NaigationView.swift
//  DriverAssistant
//
//  Created by David Kirchhoff on 2021-07-14.
//

import SwiftUI


struct NavigationView: View {
    @State private var isHidden: Bool = false

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                    NavigationLink(destination: Settings()) {
                    VStack {
                        Image("baseline_settings_black_24pt")
                        .foregroundColor(Color(Constants.InterfaceColours.navigation))
                        Text("Settings")
                        .font(.caption)
                        .foregroundColor(Color(Constants.InterfaceColours.navigation))
                        }
                    }
                    Spacer()
                }
            .opacity(isHidden ? 0: 1)
        }
        .contentShape(Rectangle()) // Makes full screen tapable
        .navigationBarHidden(true)
        .gesture(TapGesture()
                    .onEnded{isHidden.toggle()} )
    }
}

struct NaigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
