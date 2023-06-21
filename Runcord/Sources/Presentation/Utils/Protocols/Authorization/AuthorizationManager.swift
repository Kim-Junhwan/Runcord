//
//  AuthorizationManager.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/31.
//

enum AuthorizationStatus {
    case hasAuthorization
    case needAuthorization
    case notYet
}

protocol AuthorizationManager {
    func getAuthorizationStatus() -> AuthorizationStatus
    func requestAuthorization()
}
