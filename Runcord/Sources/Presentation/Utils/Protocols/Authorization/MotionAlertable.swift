//
//  MotionAlertable.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/11/12.
//

import Foundation
import CoreMotion
import UIKit

protocol ActivityAlertable: AuthorizationAlertable {
    var activityManager: CMMotionActivityManager { get }
}

extension ActivityAlertable where Self: UIViewController {
    func checkActivityMotionAuthorization(completion: () -> Void) {
        checkAuthorization(authorizationManager: activityManager, title: "모션 및 피트니스 데이터 액세스를 허용해야 합니다", message: "보다 정확한 러닝 측정을 위해 설정에서 모션 및 피트니스 권한을 허용해주세요") {
            completion()
        }
    }
}

extension CMMotionActivityManager: AuthorizationManager {
    func getAuthorizationStatus() -> AuthorizationStatus {
        switch CMMotionActivityManager.authorizationStatus() {
        case .notDetermined:
            return .notYet
        case .restricted, .denied:
            return .needAuthorization
        case .authorized:
            return .hasAuthorization
        @unknown default:
            fatalError()
        }
    }
    
    func requestAuthorization() {
        startActivityUpdates(to: .main) { _ in }
    }
}
