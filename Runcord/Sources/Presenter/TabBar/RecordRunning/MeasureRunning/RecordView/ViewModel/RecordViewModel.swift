//
//  RecordViewModel.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/04.
//

import Foundation
import RxSwift
import RxCocoa

class RecordViewModel {
    
    //MARK: - Timer Properties
    private var runningHour: Int = 0
    private var runningMinute: Int = 0
    private var runningSecond: Int = 0
    private var timer: Timer?
    let timerText: BehaviorRelay<String> = BehaviorRelay(value: "00:00:00")
    var isRunning: Bool = false
    
    var runningDistance: BehaviorRelay<Float> = BehaviorRelay(value: 0.0)
    
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
        runningSecond += 1
        if runningSecond == 60 {
            runningSecond = 0
            runningMinute += 1
            if runningMinute == 60 {
                runningMinute = 0
                runningHour += 1
            }
        }
        timerText.accept("\(String(format: "%02d", runningHour)):\(String(format: "%02d", runningMinute)):\(String(format: "%02d", runningSecond))")
    }
    
    deinit {
        print("deinit record viewModel")
    }
    
}
