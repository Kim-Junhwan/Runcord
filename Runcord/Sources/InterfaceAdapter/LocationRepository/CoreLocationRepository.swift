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
        print(coreLocationManager.authorizationStatus.rawValue)
        switch coreLocationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied:
            coreLocationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }
    
}

extension CoreLocationRepository: CLLocationManagerDelegate {
    
}
