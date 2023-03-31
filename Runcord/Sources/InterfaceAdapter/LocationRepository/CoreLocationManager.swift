//
//  CoreLocationRepository.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/30.
//

import CoreLocation

protocol CoreLocationManagerDelegate: AnyObject {
    func didChangeAuthorization(status: AuthorizationStatus)
    func getCurrentLocation(latitude: Double, longitude: Double)
}

class CoreLocationManager: NSObject, AuthorizationManager {
    
    let coreLocationManager = CLLocationManager()
    
    var delegate: CoreLocationManagerDelegate?
    
    override init() {
        super.init()
        coreLocationManager.delegate = self
    }
    
    func getAuthorizationStatus() -> AuthorizationStatus {
        switch coreLocationManager.authorizationStatus {
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
        coreLocationManager.requestWhenInUseAuthorization()
    }
}

extension CoreLocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            delegate?.didChangeAuthorization(status: .hasAuthorization)
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        delegate?.getCurrentLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}
