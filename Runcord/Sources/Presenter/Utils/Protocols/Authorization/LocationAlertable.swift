//
//  LocationAlertable.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/31.
//

import UIKit
import CoreLocation

protocol LocationAlertable: AuthorizationAlertable {
    var locationManager: CLLocationManager { get }
}

extension LocationAlertable where Self: UIViewController {
    func checkLocationAuthorization(completion: () -> Void) {
        checkAuthorization(authorizationManager: locationManager, title: "위치 권한이 필요합니다.", message: "설정에서 위치권환을 부여해주십시오.", completion: completion)
    }
}
