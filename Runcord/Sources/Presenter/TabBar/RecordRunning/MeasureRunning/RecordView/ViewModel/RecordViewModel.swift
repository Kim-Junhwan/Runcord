//
//  RecordViewModel.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/04.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

class RecordViewModel: NSObject {
    
    // MARK: - Timer Properties
    private var timer: Timer?
    let timerText: BehaviorRelay<String> = BehaviorRelay(value: "00:00:00")
    let totalRunningSecond: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var isRunning: Bool = false
    let runningDistance: BehaviorRelay<Float> = BehaviorRelay(value: 0.0)
    let locationService: LocationService
    
    // MARK: - Goal Properties
    var goalTime: Int
    var goalDistance: Double
    
    // MARK: - Route Properties
    private let route: BehaviorRelay<[CLLocation]> = BehaviorRelay(value: [])
    var routeDriver: Driver<[CLLocation]> {
        return route
            .filter { $0.count >= 2 }
            .map { $0.suffix(2) }
            .asDriver(onErrorJustReturn: [])
    }
    
    // MARK: - Speed Average
    private var speedCount = 0
    private let totalSpeed: BehaviorRelay<Double> = BehaviorRelay(value: 0.0)
    var averageSpeedDriver: Driver<Double> {
        return totalSpeed.map { speed in
            if self.speedCount > 0 {
                return self.totalSpeed.value / Double(self.speedCount)
            } else {
                return speed
            }
        }.asDriver(onErrorJustReturn: 0.0)
    }
    
    // MARK: - Taked Imagies
    var imageList: [ImageInfo] = []
    let startDate: Date = Date()
    
    let disposeBag = DisposeBag()
    let coordinator: RunningCoordinator
    
    init(goalTime: Int, goalDistance: Double, locationService: LocationService, coordinator: RunningCoordinator) {
        self.goalTime = goalTime
        self.goalDistance = goalDistance
        self.locationService = locationService
        self.coordinator = coordinator
    }
    
    // MARK: - Timer Method
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
    
    // MARK: - Location Method
    func startTrackUserLocation() {
        locationService.requestLocation()
        locationService.currentLocationSubject
            .compactMap { $0 }
            .subscribe(with: self) { owner, currentLocation in
                if owner.isRunning {
                    if let lastCoordinator = owner.route.value.last {
                        let moveDistance = owner.calculateBetweenTwoCoordinatesDistanceKilometer(lastCoordinator, currentLocation)
                        owner.runningDistance.accept(owner.runningDistance.value + moveDistance)
                        owner.speedCount += 1
                        owner.totalSpeed.accept(owner.totalSpeed.value + (Double(moveDistance * 3600)))
                    }
                }
                owner.route.accept(owner.route.value+[currentLocation])
            }.disposed(by: disposeBag)
    }
    
    private func calculateBetweenTwoCoordinatesDistanceKilometer(_ firstCoordinate: CLLocation, _ secondCoordinate: CLLocation) -> Float {
        let distance = firstCoordinate.distance(from: secondCoordinate)
        let kmDistance = distance/1000
        return Float(kmDistance)
    }
    
    // MARK: - Coordinating
    
    func showSaceRecordView() {
        let runningPath = route.value.map { $0.coordinate }.map { RunningRoute(longitude: $0.longitude, latitude: $0.latitude) }
        let runningRecord = RunningRecord(date: startDate, goalDistance: goalDistance, goalTime: goalTime, runningDistance: Double(runningDistance.value), runningTime: totalRunningSecond.value, runningPath: runningPath, imageRecords: imageList)
        coordinator.showSaveRecordView(runningRecord: runningRecord)
    }
    
    deinit {
        print("deinit record viewModel")
    }
}
