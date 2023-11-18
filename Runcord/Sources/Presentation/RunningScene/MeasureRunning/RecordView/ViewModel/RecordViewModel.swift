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
    private weak var timer: Timer?
    let runningTime: BehaviorRelay<Time> = BehaviorRelay(value: Time.zero)
    var isRunning: Bool = false
    private var lastDistance: Double = 0
    private var runningDistanceValue: Double = 0
    let runningDistance: BehaviorRelay<Distance> = BehaviorRelay(value: Distance.zero)
    unowned var locationService: LocationService
    unowned var motionService: MotionService
    
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
    private let averageSpeed: BehaviorSubject<Speed> = .init(value: .init(value: .zero))
    var averageSpeedDriver: Driver<Speed> {
        return averageSpeed.asDriver(onErrorJustReturn: .init(value: .zero))
    }
    
    // MARK: - Taked Imagies
    var imageList: [ImageInfo] = []
    let startDate: Date = Date()
    
    let disposeBag = DisposeBag()
    
    init(goalTime: Time, goalDistance: Distance, locationService: LocationService , motionService: MotionService, actions: RecordViewModelActions) {
        self.goalTime = goalTime
        self.goalDistance = goalDistance
        self.locationService = locationService
        self.motionService = motionService
        self.actions = actions
    }
    
    // MARK: - Timer Method
    func startTimer() {
        isRunning = true
        if timer != nil {
            timer?.invalidate()
        }
        motionService.startMove()
        timer = Timer.scheduledTimer(timeInterval: Metric.timerDelayTime, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        isRunning = false
        motionService.stopMove()
        runningDistanceValue = lastDistance
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
        Observable.combineLatest(locationService.currentLocationSubject.compactMap{$0}, motionService.userMoveStateSubject)
            .subscribe(with: self) { owner, value in
                let userStatus = value.1
                let runningCoordi = value.0
                if owner.isRunning && userStatus == .isMove {
                    owner.route.accept(owner.route.value+[runningCoordi])
                }
            }.disposed(by: disposeBag)
        
        locationService.currentLocationSubject
            .compactMap { $0 }
            .subscribe(with: self) { owner, currentLocation in
                owner.route.accept(owner.route.value+[currentLocation])
            }.disposed(by: disposeBag)
        
        motionService.moveDistance.subscribe(with: self) { owner, distance in
            if owner.isRunning {
                let moveDistance = (distance * 0.001) + owner.runningDistanceValue
                owner.lastDistance = moveDistance
                owner.runningDistance.accept(.init(value: moveDistance))
            }
        }.disposed(by: disposeBag)
        
        motionService.averageSpeed.subscribe(with: self) { owner, avrSpeed in
            if owner.isRunning {
                owner.averageSpeed.onNext(.init(value: (1.0/avrSpeed) * 1.60934))
            }
        }.disposed(by: disposeBag)
    }
    
    private func calculateBetweenTwoCoordinatesDistanceKilometer(_ firstCoordinate: CLLocation, _ secondCoordinate: CLLocation) -> Double {
        let distance = firstCoordinate.distance(from: secondCoordinate)
        let kmDistance = distance/Metric.coordinateConvertUnit
        return Double(kmDistance)
    }
    
    // MARK: - Coordinating
    
    func showSaveRecordView() {
        let runningPath = route.value.map { $0.coordinate }.map { RunningRoute(longitude: $0.longitude, latitude: $0.latitude) }
        let avrSpeed = try? averageSpeed.value().value
        let runningRecord = RunningRecord(date: startDate, goalDistance: goalDistance.value, goalTime: goalTime.totalSecond, runningDistance: runningDistance.value.value, runningTime: runningTime.value.totalSecond, averageSpeed: avrSpeed ?? 0.0, runningPath: runningPath, imageRecords: imageList)
        actions.showSaveRunningRecordView(runningRecord)
    }
    
    func prepareDeinit() {
        locationService.stopUpdateLocation()
        motionService.stopMove()
        timer?.invalidate()
    }
}
