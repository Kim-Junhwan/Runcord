//
//  CustomTabBar.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/13.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    var items: [UIViewController]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureTabBarController() {
        self.setViewControllers(items, animated: false)
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .black
        tabBar.tintColor = .tabBarSelect
        tabBar.layer.borderColor = UIColor.tabBarBorder?.cgColor
        tabBar.layer.borderWidth = 1
        tabBar.clipsToBounds = true
    }

}
