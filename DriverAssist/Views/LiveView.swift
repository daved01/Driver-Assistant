//
//  LiveView.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-05.
//

import SwiftUI

struct LiveView: View {
    
    
    var body: some View {
       CameraViewController()
        .edgesIgnoringSafeArea(.top)
        LiveViewButtons()
        
    }
}

struct LiveView_Previews: PreviewProvider {
    static var previews: some View {
        LiveView()
    }
}
