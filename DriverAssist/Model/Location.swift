//
//  speed.swift
//  DriverAssist
//
//  Created by David Kirchhoff on 2021-06-21.
//

import Foundation
import CoreLocation
import Combine


class LocationViewModel: NSObject, ObservableObject {
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var currentSpeed: Double = 0
    
    private let locationManager = CLLocationManager()
    
    override init() {
      super.init()
      self.locationManager.delegate = self
      self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
      self.locationManager.requestWhenInUseAuthorization()
      self.locationManager.startUpdatingLocation()
    }
}


extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let location = locations.last else { return }
        let speed = location.speed * 2.237 // m/s to mph
        
        print(Int(speed))
      userLatitude = location.coordinate.latitude
      userLongitude = location.coordinate.longitude
        currentSpeed = speed
    }
}
