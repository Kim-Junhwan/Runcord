//
//  LocationService.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/02.
//

import RxSwift

protocol LocationService {
    func getUserCurrentLocation() -> Observable<UserLocation>
}

struct UserLocation {
    let latitude: Double
    let longitude: Double
}
