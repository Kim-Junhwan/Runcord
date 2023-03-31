//
//  CoreLocationRepository.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/30.
//

import CoreLocation

class CoreLocationRepository: NSObject, LocationRepository {
    
    var delegate: LocationRepositoryDelegate?
    
    let coreLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        coreLocationManager.delegate = self
    }
    
    func requestAuthorization() {
        coreLocationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.coreLocationManager.startUpdatingLocation()
            }
        }
    }
    
    func getLocationAuthorization() -> locationAuthorizationStatus {
        switch coreLocationManager.authorizationStatus {
        case .denied, .restricted:
            return .needAuthorization
        case .authorizedAlways, .authorizedWhenInUse:
            return .hasAuthorization
        case .notDetermined:
            return .notYet
        @unknown default:
            fatalError()
        }
    }
    
}

extension CoreLocationRepository: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        delegate?.getCurrentLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}
