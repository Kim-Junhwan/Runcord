//
//  SceneDelegate.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/10.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var tabBarCoordinator: TabBarCoordinator?
    private let injector: Injector = DependencyInjector(container: Container())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        if let window = window {
            tabBarCoordinator = TabBarCoordinator(injector: injector, window: window)
            injector.assemble([
                DataAssembly(),
                DomainAssembly(),
                RunningRecordListAssembly(),
                RunningAssembly()
            ])
            tabBarCoordinator?.start()
            window.makeKeyAndVisible()
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

}

