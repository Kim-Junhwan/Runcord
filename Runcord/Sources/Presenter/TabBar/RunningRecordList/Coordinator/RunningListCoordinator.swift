//
//  MyPageCoordinator.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/13.
//

import UIKit

final class RunningListCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    let runningRecordRepository: RunningRecordRepository
    
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController, runningRecordRepository: RunningRecordRepository) {
        self.navigationController = navigationController
        self.runningRecordRepository = runningRecordRepository
    }
    
    func start() {
        let mypageViewController = RunnningRecordListViewController(viewModel: RunningRecordListViewModel(runningRecordRepository: runningRecordRepository, coordinator: self))
        navigationController.pushViewController(mypageViewController, animated: false)
    }
    
    func showDetailRunningRecord(runningRecord: RunningRecord) {
        let detailViewController = DetailRunninRecordViewController(runningRecord: runningRecord)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
}
