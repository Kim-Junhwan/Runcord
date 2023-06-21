//
//  MyPageCoordinator.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/13.
//

import UIKit

final class RunningListCoordinator: Coordinator {
    let injector: Injector
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(injector: Injector, navigationController: UINavigationController) {
        self.injector = injector
        self.navigationController = navigationController
    }
    
    func start() {
        let actions = RunningRecordListViewModelActions(showRunningRecordDetail: showDetailRunningRecord)
        let vc = injector.resolve(RunningRecordListViewController.self, argument: actions)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetailRunningRecord(runningRecord: RunningRecord) {
        let detailViewController = DetailRunninRecordViewController(runningRecord: runningRecord)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
}
