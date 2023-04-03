//
//  RecordRunningCoordinator.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/12.
//

import UIKit
import CoreLocation

final class RecordRunningCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        showRecordRunningViewController()
    }
    
    func showRecordRunningViewController() {
        self.navigationController.isNavigationBarHidden = true
        let locationManager = CLLocationManager()
        let runningStartVC = RunningStartViewController(locationManager: locationManager, viewModel: RunningStartViewModel())
        self.navigationController.pushViewController(runningStartVC, animated: false)
    }
    
    deinit {
        print("deinit recordRunningCoordinator")
    }
    
}
