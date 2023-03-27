//
//  AlarmCoordinator.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/13.
//

import UIKit

final class AlarmCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let alarmVC: AlarmViewController = .init()
        let crewAlarmVC = CrewAlarmViewController()
        crewAlarmVC.tabBarItem.title = "크루"
        let myRunningVC = MyRunningViewController()
        myRunningVC.tabBarItem.title = "마이러닝"
        alarmVC.setItems(items: [crewAlarmVC, myRunningVC])
        self.navigationController.pushViewController(alarmVC, animated: false)
    }
    
    
}
