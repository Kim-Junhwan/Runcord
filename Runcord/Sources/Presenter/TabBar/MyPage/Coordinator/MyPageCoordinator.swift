//
//  MyPageCoordinator.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/13.
//

import UIKit

final class MyPageCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mypageViewController = RunnningRecordListViewController()
        navigationController.pushViewController(mypageViewController, animated: false)
    }
    
}
