//
//  CustomTopTabBarController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/15.
//

import UIKit

class CustomTopTabBarController: UIViewController {
    
    lazy var topTabBarMenu: CustomMenuBar = {
        let menuBar = CustomMenuBar()
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        
        return menuBar
    }()
    
    lazy var pageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTabBarMenu.menuCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: [])
        pageView.addSubview(items[0].view)
    }
    
    private var items: [UIViewController] = []
    
    func setItems(items: [UIViewController]) {
        self.items = items
        var menuItemList: [MenuItem] = []
        items.forEach { vc in
            guard let vcTabBarTitle = vc.tabBarItem.title else { return }
            menuItemList.append(MenuItem(title: vcTabBarTitle, isSelect: false))
        }
        topTabBarMenu.setItems(items: menuItemList)
    }
    
}

extension CustomTopTabBarController: CustomMenuBarDelegate {
    func didSelect(indexNum: Int) {
        if pageView.subviews.contains(where: {$0.isEqual(items[indexNum].view)}) {
            pageView.subviews.forEach { view in
                view.isHidden = true
            }
            pageView.subviews.first { $0.isEqual(items[indexNum].view) }?.isHidden = false
        } else {
            pageView.subviews.forEach { view in
                view.isHidden = true
            }
            pageView.addSubview(items[indexNum].view)
            pageView.subviews.first { $0.isEqual(items[indexNum].view) }?.isHidden = false
        }
    }
}
