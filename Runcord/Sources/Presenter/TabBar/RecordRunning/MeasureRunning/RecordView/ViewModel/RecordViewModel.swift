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

class RecordViewModel: NSObject {
    
    // MARK: - Timer Properties
    private var timer: Timer?
    let timerText: BehaviorRelay<String> = BehaviorRelay(value: "00:00:00")
    let totalRunningSecond: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var isRunning: Bool = false
    var runningDistance: BehaviorRelay<Float> = BehaviorRelay(value: 0.0)
    let locationManager: CLLocationManager
    
    // MARK: - Goal Properties
    var goalTime: Int
    var goalDistance: Double
    
    // MARK: - Route Properties
    private let route: BehaviorRelay<[CLLocation]> = BehaviorRelay(value: [])
    var routeObservable: Observable<[CLLocation]> {
        return route
            .filter { $0.count >= 2 }
            .map { $0.suffix(2) }
            .asObservable()
    }
    
    func viewDidLoad() {
        locationManager.delegate = self
        
    }
    
    init(goalTime: Int, goalDistance: Double, locationManager: CLLocationManager) {
        self.goalTime = goalTime
        self.goalDistance = goalDistance
        self.locationManager = locationManager
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
        locationManager.startUpdatingLocation()
    }
    
    func calculateDistanceKilometerBetweenCoordinators(_ firstCoordinate: CLLocation, _ secondCoordinate: CLLocation) -> Float {
        let distance = firstCoordinate.distance(from: secondCoordinate)
        let kmDistance = distance/1000
        
        return Float(kmDistance)
    }
    
    deinit {
        print("deinit record viewModel")
    }
}

extension RecordViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        if !route.value.isEmpty {
            guard let lastLocation = route.value.last else { return }
            
            if isRunning {
                runningDistance.accept(runningDistance.value + calculateDistanceKilometerBetweenCoordinators(lastLocation, currentLocation))
            }
        }
        route.accept(route.value + [currentLocation])
    }
}
