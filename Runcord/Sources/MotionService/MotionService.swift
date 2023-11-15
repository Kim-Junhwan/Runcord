//
//  MotionService.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/11/15.
//

import Foundation
import CoreMotion
import RxSwift

enum RunningState {
    case isMove
    case stop
}

protocol MotionService: AuthorizationManager {
    var userMoveStateSubject: PublishSubject<RunningState> { get }
}

final class CMMotionActivityManagerMotionService: MotionService {
    
    private let motionManager = CMMotionActivityManager()
    
    var userMoveStateSubject: PublishSubject<RunningState> = .init()
    
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
        motionManager.startActivityUpdates(to: .main) { _ in }
    }
    
    init() {}
    
    private func startActivityUpdate() {
        motionManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let activity else { return }
            if activity.running || activity.walking {
                if !activity.stationary {
                    self?.userMoveStateSubject.onNext(.isMove)
                } else {
                    self?.userMoveStateSubject.onNext(.stop)
                }
            } else {
                self?.userMoveStateSubject.onNext(.stop)
            }
        }
    }
}
