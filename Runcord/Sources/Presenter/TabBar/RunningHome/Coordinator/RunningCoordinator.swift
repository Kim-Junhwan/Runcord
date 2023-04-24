//
//  RecordRunningCoordinator.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/12.
//

import UIKit
import CoreLocation

final class RunningCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    let locationManager: CLLocationManager = CLLocationManager()
    
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
        let recordRunningViewController = RecordViewController(viewModel: RecordViewModel(goalTime: goalTime, goalDistance: goalDistance, locationManager: locationManager))
        recordRunningViewController.modalPresentationStyle = .fullScreen
        navigationController.present(recordRunningViewController, animated: false)
    }
    
    deinit {
        print("deinit recordRunningCoordinator")
    }
    
}
