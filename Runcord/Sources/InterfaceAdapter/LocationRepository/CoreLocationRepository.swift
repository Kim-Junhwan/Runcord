//
//  CoreLocationRepository.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/30.
//

import CoreLocation

class CoreLocationRepository: NSObject, LocationRepository {
    
    let coreLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        coreLocationManager.delegate = self
    }
    
    func checkLocationAuthorization() -> Bool {
        switch coreLocationManager.authorizationStatus {
        case .denied, .restricted, .notDetermined:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        @unknown default:
            fatalError()
        }
    }
    
}

extension CoreLocationRepository: CLLocationManagerDelegate {
    
}
