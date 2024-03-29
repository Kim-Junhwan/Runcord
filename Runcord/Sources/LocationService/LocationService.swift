//
//  LocationService.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/02.
//

import CoreLocation
import RxSwift

protocol LocationService: AuthorizationManager, AnyObject {
    var currentLocationSubject: BehaviorSubject<CLLocation?> { get }
    var locationError: PublishSubject<Error> { get }
    var locationAuthorizationSubject: BehaviorSubject<CLAuthorizationStatus> { get }
    func requestLocation()
    func stopUpdateLocation()
}

final class DefaultLocationService: NSObject, LocationService {
    
    private let locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 5
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationAuthorizationSubject.onNext(locationManager.authorizationStatus)
    }
    
    let currentLocationSubject: BehaviorSubject<CLLocation?> = BehaviorSubject(value: nil)
    var locationError: PublishSubject<Error> = .init()
    let locationAuthorizationSubject: BehaviorSubject<CLAuthorizationStatus> = BehaviorSubject(value: .denied)
    
    func requestLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func getAuthorizationStatus() -> AuthorizationStatus {
        switch locationManager.authorizationStatus {
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
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension DefaultLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        currentLocationSubject.onNext(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError.onNext(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorizationSubject.onNext(manager.authorizationStatus)
    }
    
}
