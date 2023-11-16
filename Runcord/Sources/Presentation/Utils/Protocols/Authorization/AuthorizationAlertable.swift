//
//  AuthorizationAlertable.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/31.
//

import UIKit

protocol AuthorizationAlertable: Alertable {
    func checkAuthorization(authorizationManager: AuthorizationManager, title: String, message: String, completion: () -> Void)
}

extension AuthorizationAlertable where Self: UIViewController {
    func checkAuthorization(authorizationManager: AuthorizationManager, title: String, message: String, completion: () -> Void) {
        switch authorizationManager.getAuthorizationStatus() {
        case .hasAuthorization:
            completion()
        case .needAuthorization:
            showAuthorizationAlert(title: title, message: message)
        case .notYet:
            authorizationManager.requestAuthorization()
        }
    }
    
    private func showAuthorizationAlert(title: String, message: String) {
        showAlert(title: title, message: message, defaultActionTitle: "설정", cancelActionTitle: "취소") { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
