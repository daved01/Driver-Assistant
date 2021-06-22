//
//  speed.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-21.
//

import UIKit
import Foundation
import CoreLocation

class SpeedViewController: UIViewController, CLLocationManagerDelegate, ObservableObject {
    @Published var currentSpeed = 0
    let manager = CLLocationManager()
    //var currentSpeed = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.requestWhenInUseAuthorization()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.startUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location?.speed)
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
}
