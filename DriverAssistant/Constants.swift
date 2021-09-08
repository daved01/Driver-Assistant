//
//  Constants.swift
//  DriverAssistant
//
//  Created by David Kirchhoff on 2021-09-07.
//

import Foundation
import UIKit

struct Constants {
    struct BoxColours {
        static let misc = CGColor.init(red: 100.0/255.0, green: 149.0/255.0, blue: 237.0/255.0, alpha: 1.0) // Cornflower blue
        static let trafficRed = CGColor.init(red: 255.0/255.0, green: 30.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        static let trafficNa = CGColor.init(red: 249.0/255.0, green: 205.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        static let trafficGreen = CGColor.init(red: 8.0/255.0, green: 206.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        static let pedestrian = CGColor.init(red: 255.0/255.0, green: 165.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
    struct TextColours {
        static let light = CGColor.init(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        static let dark = CGColor.init(red: 47.0/255.0, green: 46.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    }
    
}
