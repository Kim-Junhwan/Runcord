//
//  RecordViewModel.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/04.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class RecordViewModel {
    
    // MARK: - Timer Properties
    private var timer: Timer?
    let timerText: BehaviorRelay<String> = BehaviorRelay(value: "00:00:00")
    let totalRunningSecond: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var isRunning: Bool = false
    var runningDistance: BehaviorRelay<Float> = BehaviorRelay(value: 0.0)
    
    // MARK: - Goal Properties
    var goalTime: Int
    var goalDistance: Double
    
    // MARK: - Route Properties
    var route: [CLLocation] = []
    
    init(goalTime: Int, goalDistance: Double) {
        self.goalTime = goalTime
        self.goalDistance = goalDistance
    }
    
    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
    }
    
    func deinitViewModel() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc private func timerCallBack() {
        totalRunningSecond.accept(totalRunningSecond.value + 1)
        setTimerText()
    }
    
    private func setTimerText() {
        let hours = totalRunningSecond.value / 3600
        let minutes = (totalRunningSecond.value % 3600) / 60
        let seconds = totalRunningSecond.value % 60
        timerText.accept("\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
    }
    
    deinit {
        print("deinit record viewModel")
    }
}
