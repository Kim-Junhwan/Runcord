//
//  TabBarCoordinator.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/12.
//

import UIKit

final class TabBarCoordinator {
    var window: UIWindow
    var tabBarController: DesignedTabBarController
    var childCoordinators: [Coordinator]
    
    init(_ window: UIWindow) {
        self.window = window
        self.tabBarController = DesignedTabBarController()
        self.childCoordinators = []
    }
    
    func start() {
        self.window.rootViewController = tabBarController
        let items: [TabBarItem] = [.recordRunning, .recordRunningList].sorted { $0.rawValue < $1.rawValue }
        let controllers = items.map { getTabController($0) }
        tabBarController.viewControllers = controllers
    }
    
    func getTabController(_ item: TabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .black
        navigationController.tabBarItem = .init(title: item.itemTitleValue(), image: item.itemImageValue(), tag: item.rawValue)
        navigationController.navigationBar.titleTextAttributes = [.font: UIFont(name: "NotoSansKR-Medium", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)]
        setTabCoordinator(of: item, to: navigationController)
        return navigationController
    }
    
    func setTabCoordinator(of item: TabBarItem, to navigationController: UINavigationController) {
        var coordinator: Coordinator? = nil
        switch item {
        case .recordRunning:
            coordinator = RunningCoordinator(navigationController)
        case .recordRunningList:
            coordinator = MyPageCoordinator(navigationController)
        }
        if let coordinator = coordinator {
            childCoordinators.append(coordinator)
            coordinator.start()
        }
    }
    
    deinit {
        print("deinit tabbar coordinator")
    }
    
}
