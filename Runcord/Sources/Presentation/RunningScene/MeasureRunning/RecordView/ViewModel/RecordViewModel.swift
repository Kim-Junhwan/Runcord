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

struct RecordViewModelActions {
    let showSaveRunningRecordView: (RunningRecord) -> Void
    let showRunningRecordMapView: () -> Void
}

class RecordViewModel: NSObject {
    
    enum Metric {
        static let speed: Double = .zero
        static let speedUnit: Double = 3600.0
        static let coordinateConvertUnit: Double = 1000.0
        static let timerDelayTime: Double = 1.0
    }
    
    let actions: RecordViewModelActions
    
    // MARK: - Timer Properties
    private var timer: Timer?
    let runningTime: BehaviorRelay<Time> = BehaviorRelay(value: Time.zero)
    var isRunning: Bool = false
    let runningDistance: BehaviorRelay<Distance> = BehaviorRelay(value: Distance.zero)
    let locationService: LocationService
    
    // MARK: - Goal Properties
    var goalTime: Time
    var goalDistance: Distance
    
    // MARK: - Route Properties
    private let route: BehaviorRelay<[CLLocation]> = BehaviorRelay(value: [])
    var routeDriver: Driver<[CLLocation]> {
        return route
            .asDriver(onErrorJustReturn: [])
    }
    
    // MARK: - Speed Average
    private var speedCount = 0
    private let totalSpeed: BehaviorRelay<Speed> = BehaviorRelay(value: Speed.zero)
    var averageSpeedDriver: Driver<Speed> {
        return totalSpeed.map{
            if self.speedCount == 0 {
                return Speed.zero
            }
            return Speed(value: $0.value / Double(self.speedCount)) }.asDriver(onErrorJustReturn: Speed.zero)
    }
    
    // MARK: - Taked Imagies
    var imageList: [ImageInfo] = []
    let startDate: Date = Date()
    
    let disposeBag = DisposeBag()
    
    init(goalTime: Time, goalDistance: Distance, locationService: LocationService, actions: RecordViewModelActions) {
        self.goalTime = goalTime
        self.goalDistance = goalDistance
        self.locationService = locationService
        self.actions = actions
    }
    
    // MARK: - Timer Method
    func startTimer() {
        isRunning = true
        if timer != nil {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: Metric.timerDelayTime, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
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
        runningTime.accept(Time(seconds: runningTime.value.totalSecond+1))
    }
    
    // MARK: - Location Method
    func startTrackUserLocation() {
        locationService.requestLocation()
        locationService.currentLocationSubject
            .compactMap { $0 }
            .subscribe(with: self) { owner, currentLocation in
                if owner.isRunning {
                    owner.updateRunningRecord(updatedLocation: currentLocation)
                }
                owner.route.accept(owner.route.value+[currentLocation])
            }.disposed(by: disposeBag)
    }
    
    private func updateRunningRecord(updatedLocation: CLLocation) {
        if let lastCoordinator = self.route.value.last {
            let moveDistance = self.calculateBetweenTwoCoordinatesDistanceKilometer(lastCoordinator, updatedLocation)
            self.runningDistance.accept(Distance(value: Double(self.runningDistance.value.value + moveDistance)))
            self.speedCount += 1
            self.totalSpeed.accept(totalSpeed.value + Speed(value: Double(moveDistance * Metric.speedUnit)))
        }
    }
    
    private func calculateBetweenTwoCoordinatesDistanceKilometer(_ firstCoordinate: CLLocation, _ secondCoordinate: CLLocation) -> Double {
        let distance = firstCoordinate.distance(from: secondCoordinate)
        let kmDistance = distance/Metric.coordinateConvertUnit
        return Double(kmDistance)
    }
    
    // MARK: - Coordinating
    
    func showSaveRecordView() {
        let runningPath = route.value.map { $0.coordinate }.map { RunningRoute(longitude: $0.longitude, latitude: $0.latitude) }
        let runningRecord = RunningRecord(date: startDate, goalDistance: goalDistance.value, goalTime: goalTime.totalSecond, runningDistance: runningDistance.value.value, runningTime: runningTime.value.totalSecond, averageSpeed: totalSpeed.value.value/Double(speedCount), runningPath: runningPath, imageRecords: imageList)
        actions.showSaveRunningRecordView(runningRecord)
    }
    
    deinit {
        locationService.stopUpdateLocation()
        print("deinit record viewModel")
    }
}
