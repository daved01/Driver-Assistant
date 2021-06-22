//
//  speed.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-21.
//

import SwiftUI
import UIKit
import Foundation
import CoreLocation

final class SpeedViewController: UIViewController, CLLocationManagerDelegate, ObservableObject {
   
    let manager = CLLocationManager()
    @Published var currentSpeed: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest // Sets the accuracy - sampling rate?
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        print("Starting")
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        currentSpeed = Int(location.speed)
        print(currentSpeed!)
    }

    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
    


}


extension SpeedViewController : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SpeedViewController {
        return SpeedViewController()
    }
    
    func updateUIViewController(_ uiViewController: SpeedViewController, context: Context) {
    }
    
    public typealias UIViewControllerType = SpeedViewController
    
}
