//
//  TestView.swift
//  DriverAssistant
//
//  Created by David Kirchhoff on 2021-07-16.
//

import SwiftUI

struct TestView: View {
    @ObservedObject var sign = VisionObjectRecognitionViewController()
    //@StateObject var sign = VisionObjectRecognitionViewController()
            
    var body: some View {
        //SwiftUIViewController(identifier: showStopSign)
        Text("True")
            .background(Color.blue)
            .opacity(sign.showStopSign ? 0 : 1)
    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

