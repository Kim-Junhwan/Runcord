//
//  LocationServiceImpl.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/02.
//

import RxSwift
import CoreLocation

final class LocationService: NSObject {
    
    let locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    func getUserCurrentLocation() -> Observable<CLLocationCoordinate2D> {
        return Observable.create(<#T##subscribe: (AnyObserver<_>) -> Disposable##(AnyObserver<_>) -> Disposable#>)
    }
    
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        
    }
}
