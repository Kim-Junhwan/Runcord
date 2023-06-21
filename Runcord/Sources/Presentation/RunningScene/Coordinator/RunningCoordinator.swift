//
//  RecordRunningCoordinator.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/12.
//

import CoreLocation
import MapKit
import UIKit

final class RunningCoordinator: Coordinator {
    let injector: Injector
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    let locationService: LocationService
    
    init(injector: Injector, navigationController: UINavigationController) {
        self.injector = injector
        self.navigationController = navigationController
        self.locationService = injector.resolve(LocationService.self)
    }
    
    func start() {
        let action = RunningStartViewModelActions(showRecordView: showRecordRunningView(goalTime:goalDistance:))
        let runningStartVC = injector.resolve(RunningStartViewController.self, argument: action)
        self.navigationController.pushViewController(runningStartVC, animated: false)
    }
    
    func showRecordRunningView(goalTime: Int, goalDistance: Double) {
        let actions = RecordViewModelActions(showSaveRunningRecordView: showSaveRecordView, showRunningRecordMapView: showRunningRecordMapView)
        let recordViewModel = injector.resolve(RecordViewModel.self, argument: goalTime, arg2: goalDistance, arg3: actions)
        let recordRunningViewController = injector.resolve(RecordViewController.self, argument: recordViewModel)
        recordRunningViewController.modalPresentationStyle = .fullScreen
        navigationController.present(recordRunningViewController, animated: false)
    }
    
    func showSaveRecordView(runningRecord: RunningRecord) {
        let vc = injector.resolve(SaveRecordRunningViewController.self, argument: runningRecord)
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
    }
    
    func showRunningRecordMapView() {
        
    }
    
    deinit {
        print("deinit recordRunningCoordinator")
    }
}
