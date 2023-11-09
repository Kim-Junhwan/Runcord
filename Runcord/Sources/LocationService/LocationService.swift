//
//  LocationService.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/02.
//

import CoreLocation
import CoreMotion
import RxSwift

protocol LocationService: AuthorizationManager {
    var currentLocationSubject: BehaviorSubject<CLLocation?> { get }
    var locationAuthorizationSubject: BehaviorSubject<CLAuthorizationStatus> { get }
    func requestLocation()
    func stopUpdateLocation()
}

final class DefaultLocationService: NSObject, LocationService {
    
    private let locationManager: CLLocationManager
    private let motionManager = CMMotionActivityManager()
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationAuthorizationSubject.onNext(locationManager.authorizationStatus)
    }
    
    let currentLocationSubject: BehaviorSubject<CLLocation?> = BehaviorSubject(value: nil)
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
    }
    
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension DefaultLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        motionManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let activity = activity else { return }
            print(activity.running)
            print(activity.walking)
            if activity.running || activity.walking{
                if !activity.stationary {
                    self?.locationManager.startUpdatingLocation()
                    self?.currentLocationSubject.onNext(currentLocation)
                } else {
                    self?.locationManager.stopUpdatingLocation()
                }
            } else {
                self?.locationManager.stopUpdatingLocation()
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocationSubject.onError(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorizationSubject.onNext(manager.authorizationStatus)
    }
    
}
