//
//  LiveView.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-05.
//

import SwiftUI

struct LiveView: View {
    var detect = false
    
    var body: some View {
        VStack {
        Text("Live View")
        .padding(EdgeInsets(top:10, leading:20, bottom:10, trailing: 20))
        }
    }
}

struct LiveView_Previews: PreviewProvider {
    static var previews: some View {
        LiveView()
    }
}
