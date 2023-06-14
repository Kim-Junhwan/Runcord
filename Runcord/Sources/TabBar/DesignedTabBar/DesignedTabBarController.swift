//
//  DesignedTabBarController.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/27.
//

import UIKit

class DesignedTabBarController: UITabBarController {
    
    private enum TabBarItem {
        static let itemFontSize: CGFloat = 12.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    private func setTabBar() {
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .black
        tabBar.tintColor = .tabBarSelect
        tabBar.clipsToBounds = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.mediumNotoSansFont(ofSize: TabBarItem.itemFontSize)], for: .normal)
    }

}
