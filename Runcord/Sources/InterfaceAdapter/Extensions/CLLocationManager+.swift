//
//  CoreLocationRepository.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/30.
//

import CoreLocation

extension CLLocationManager: AuthorizationManager {
    
    func getAuthorizationStatus() -> AuthorizationStatus {
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return .hasAuthorization
        case .restricted, .denied:
            return .needAuthorization
        case .notDetermined:
            return .notYet
        default:
            fatalError()
        }
    }
    
    func requestAuthorization() {
        requestWhenInUseAuthorization()
    }
}
