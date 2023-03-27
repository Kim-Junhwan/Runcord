//
//  RecordRunningCoordinator.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/12.
//

import UIKit

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
        let recordVC: RecordRunningViewController = RecordRunningViewController()
        self.navigationController.pushViewController(recordVC, animated: false)
        recordVC.delegate = self
    }
    
    deinit {
        print("deinit recordRunningCoordinator")
    }
    
}


extension RecordRunningCoordinator: RecordRunningViewControllerDelegate {
    
    func showIndividualView() {
        self.navigationController.pushViewController(RunningStartViewController(viewModel: RunningStartViewModel(viewTitle: "개인러닝")), animated: true)
    }
    
    func showCrewView() {
        self.navigationController.pushViewController(MyRunningViewController(), animated: true)
    }
    
    
}
