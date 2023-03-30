//
//  DesignedTabBarController.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/27.
//

import UIKit

class DesignedTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    private func setTabBar() {
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .black
        tabBar.tintColor = .tabBarSelect
        tabBar.layer.borderColor = UIColor.tabBarBorder?.cgColor
        tabBar.layer.borderWidth = 1
        tabBar.clipsToBounds = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Medium", size: 12)!], for: .normal)
    }

}
