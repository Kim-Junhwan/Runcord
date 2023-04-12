//
//  RunningStartViewModel.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/01.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

class RunningStartViewModel {
    
    private let coordinator: RunningCoordinator
    
    var goalDistance: BehaviorRelay<Double> = BehaviorRelay<Double>(value: 3.00)
    var goalHour: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var goalMinute: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 30)
    var goalTimeRelay = BehaviorRelay<String>(value: "")
    
    let disposeBag = DisposeBag()
    
    init(coordinator: RunningCoordinator) {
        self.coordinator = coordinator
        Observable.combineLatest(goalHour, goalMinute).map({ hour, minute in
            "\(String(format: "%.2d", hour)):\(String(format: "%.2d", minute))"
        }).bind(to: goalTimeRelay)
            .disposed(by: disposeBag)
    }
    
    func setGoalDistance(goal: String) {
        let distance = (goal as NSString).doubleValue
        goalDistance.accept(distance)
    }
    
    func setGoalTime(goal: String) {
        let splGoal = goal.split(separator: ":").map { Int($0)! }
        var hour = splGoal[0]
        var minute = splGoal[1]
        if minute >= 60 {
            minute = minute % 60
            hour += 1
        }
        goalHour.accept(hour)
        goalMinute.accept(minute)
    }
    
    func presentRecordView() {
        coordinator.showRecordRunningView(goalTime: convertTimeToSecond(hour: goalHour.value, minute: goalMinute.value), goalDistance: goalDistance.value)
    }
    
    private func convertTimeToSecond(hour: Int, minute: Int) -> Int {
        let hourToSecond = hour*60 * 60
        let minuteToSecond = minute * 60
        return hourToSecond + minuteToSecond
    }
    
}
