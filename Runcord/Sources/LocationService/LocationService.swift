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
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationAuthorizationSubject.onNext(locationManager.authorizationStatus)
    }
    
    let currentLocationSubject: BehaviorSubject<CLLocation?> = BehaviorSubject(value: nil)
    let locationAuthorizationSubject: BehaviorSubject<CLAuthorizationStatus> = BehaviorSubject(value: .denied)
    
    func requestLocation() {
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        currentLocationSubject.onNext(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocationSubject.onError(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorizationSubject.onNext(manager.authorizationStatus)
    }
    
}
