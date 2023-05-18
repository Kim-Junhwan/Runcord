//
//  RecordRunningCoordinator.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/12.
//

import UIKit
import CoreLocation
import MapKit

final class RunningCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    let locationManager: CLLocationManager = CLLocationManager()
    let locationService: LocationService = LocationService(locationManager: CLLocationManager())
    let runningRecordRepository: RunningRecordRepository = DefaultRunningRecordRepository(coreDataStorage: CoreDataRunningRecordStroage())
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        showStartRunningView()
    }
    
    func showStartRunningView() {
        self.navigationController.isNavigationBarHidden = true
        let runningStartVC = RunningStartViewController(viewModel: RunningStartViewModel(coordinator: self), locationManager: locationManager)
        self.navigationController.pushViewController(runningStartVC, animated: false)
    }
    
    func showRecordRunningView(goalTime: Int, goalDistance: Double) {
        let recordRunningViewController = RecordViewController(viewModel: RecordViewModel(goalTime: goalTime, goalDistance: goalDistance, locationService: locationService, coordinator: self))
        recordRunningViewController.modalPresentationStyle = .fullScreen
        navigationController.present(recordRunningViewController, animated: false)
    }
    
    func showSaveRecordView(runningRecord: RunningRecord) {
        let vc = SaveRecordRunningViewController(runningRecord: runningRecord, runningRecordRepository: runningRecordRepository)
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
    }
    
    deinit {
        print("deinit recordRunningCoordinator")
    }
    
}
