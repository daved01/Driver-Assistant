//
//  LocationViewController.swift
//  DriverAssistant
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
    @Published var unitString: String = "MPH"
    
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
    
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
        
        // Get speed in either unit
        let metricUnits = UserDefaults.standard.bool(forKey: "metricUnits")
        var speed = location.speed
        
        // Prevent the negative speed indication when moving slowly
        if speed < 0.5 {
            speed = 0
        }
        if metricUnits == false {
            speed = speed * 2.237 // m/s to mph
            unitString = "MPH"
        }
        else {
            speed = speed * 3.6 // m/s to kph
            unitString = "km/h"
        }
        currentSpeed = speed
    }
}

