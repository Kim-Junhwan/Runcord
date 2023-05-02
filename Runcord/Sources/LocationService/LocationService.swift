//
//  LocationService.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/02.
//

import RxSwift
import CoreLocation

final class LocationService: NSObject {
    
    private let locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
    }
    
    let currentLocationSubject: BehaviorSubject<CLLocationCoordinate2D?> = BehaviorSubject(value: nil)
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        currentLocationSubject.onNext(currentLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocationSubject.onError(error)
    }
    
}
