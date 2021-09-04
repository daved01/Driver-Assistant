//
//  DisplayView.swift
//  DriverAssistant
//
//  Created by David Kirchhoff on 2021-06-21.
//

import SwiftUI



struct DisplayView: View {
    @ObservedObject var locationViewModel = LocationViewModel()
    let showSpeed = UserDefaults.standard.bool(forKey: "showSpeed")

    var body: some View {
            HStack {
                Spacer()
                if self.showSpeed == true {
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
                }
                Spacer()
                // Icon
            }
            .navigationBarHidden(true)
    }
}

struct Display_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView()
    }
}

