//
//  RunningStartViewModel.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/01.
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift

struct RunningStartViewModelActions {
    let showRecordView: (Int, Double) -> Void
}

class RunningStartViewModel {
    
    private enum Default {
        static let defaultDistance: Double = 3.0
        static let defaultTime: Int = 1800
    }
    
    private let actions: RunningStartViewModelActions
    
    var goalDistance: BehaviorRelay<Distance> = BehaviorRelay<Distance>(value: Distance(value: Default.defaultDistance))
    var goalDistanceValue: String {
        get {
            return goalDistance.value.formattedDistanceToString(type: .defaultFormat)
        }
    }
    
    var goalTime: BehaviorRelay<Time> = BehaviorRelay<Time>(value: Time(seconds: Default.defaultTime))

    
    var goalTimeValue: String {
        get {
            return goalTime.value.formatedTimeToString(format: .goalDistanceFormat)
        }
    }
    
    init(actions: RunningStartViewModelActions) {
        self.actions = actions
    }
    
    func setGoalDistance(distance: Distance) {
        goalDistance.accept(distance)
    }
    
    func setGoalTime(time: Time) {
        goalTime.accept(time)
    }
    
    func presentRecordView() {
        
    }
}
