//
//  Display.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-21.
//

import SwiftUI

struct Display: View {
   
    @State var speed = SpeedViewController()
    
    var body: some View {
            HStack {
                Spacer()
                    VStack {
                        
                        //Text("\(speed.currentSpeed)")
                        Text("27")
                        
                    .font(.system(size: 82.0))
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                Text("MPH")
                    .foregroundColor(.white)
                    .fontWeight(.light)
                    .font(.system(size: 38.0))
                Spacer()
                    }
            // Icon
                Spacer()
                VStack {
                    Image("test-stop-sign")
                        .frame(width: 32.0, height: 32.0)
                        .padding(40.0)
                        .accentColor(.red)
                    Spacer()
                }
            }
    }
}

struct Display_Previews: PreviewProvider {
    static var previews: some View {
        Display()
    }
}
