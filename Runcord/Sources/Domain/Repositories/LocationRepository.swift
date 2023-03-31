//
//  LocationRepository.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/30.
//

enum locationAuthorizationStatus {
    case needAuthorization
    case hasAuthorization
    case notYet
}

protocol LocationRepositoryDelegate: AnyObject {
    func getCurrentLocation(latitude: Double, longitude: Double)
}

protocol LocationRepository {
    var delegate: LocationRepositoryDelegate? { get set }
    func requestAuthorization()
    func getLocationAuthorization() -> locationAuthorizationStatus
}
