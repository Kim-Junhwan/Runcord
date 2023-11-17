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
    var moveDistance: PublishSubject<Double> { get }
    var averageSpeed: PublishSubject<Double> { get }
    func startActivityUpdate()
    func stopMove()
    func startMove()
}

final class CMMotionActivityManagerMotionService: MotionService {
    
    
    
    private let motionManager = CMMotionActivityManager()
    private let pedoMeter = CMPedometer()
    
    var userMoveStateSubject: PublishSubject<RunningState> = .init()
    var moveDistance: PublishSubject<Double> = .init()
    var averageSpeed: PublishSubject<Double> = .init()
    
    init() {}
    
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
    
    func stopMove() {
        pedoMeter.stopUpdates()
    }
    
    func startMove() {
        if CMPedometer.isDistanceAvailable() {
            pedoMeter.startUpdates(from: Date()) { [weak self] data, error in
                if let error {
                    print(error)
                    return
                }
                guard let data, let distance = data.distance?.doubleValue, let avrSpeed = data.averageActivePace?.doubleValue else { return }
                self?.moveDistance.onNext(distance)
                self?.averageSpeed.onNext(avrSpeed)
            }
        }
    }
    
    func requestAuthorization() {
        motionManager.startActivityUpdates(to: .main) { _ in }
    }
    
    func startActivityUpdate() {
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
