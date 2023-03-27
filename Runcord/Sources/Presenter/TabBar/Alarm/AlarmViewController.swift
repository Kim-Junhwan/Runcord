//
//  AlarmViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/13.
//

import UIKit

class AlarmViewController: CustomTopTabBarController {
    
    lazy var topTabBarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        addView()
        setConstraint()
        topTabBarMenu.delegate = self
    }
    
    func setNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.topItem?.title = "알림"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20)]
    }
    
    //MARK: - Set UI
    
    func addView() {
        view.addSubview(topTabBarContainer)
        topTabBarContainer.addSubview(topTabBarMenu)
        view.addSubview(pageView)
    }
    
    func setConstraint() {
        setTopTabContainer()
        setTopTabBarConstraint()
        setPageViewConstraint()
    }
    
    func setTopTabContainer() {
        NSLayoutConstraint.activate([
            topTabBarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topTabBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topTabBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topTabBarContainer.heightAnchor.constraint(equalToConstant: view.frame.height * (Double(120)/Double(1624)))
        ])
    }
    
    func setTopTabBarConstraint() {
        NSLayoutConstraint.activate([
            topTabBarMenu.topAnchor.constraint(equalTo: topTabBarContainer.topAnchor),
            topTabBarMenu.leadingAnchor.constraint(equalTo: topTabBarContainer.leadingAnchor),
            topTabBarMenu.trailingAnchor.constraint(equalTo: topTabBarContainer.trailingAnchor),
            topTabBarMenu.bottomAnchor.constraint(equalTo: topTabBarContainer.bottomAnchor)
        ])
    }
    
    func setPageViewConstraint() {
        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: topTabBarContainer.bottomAnchor),
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

