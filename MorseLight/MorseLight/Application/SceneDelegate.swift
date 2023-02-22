//
//  SceneDelegate.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 20.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let tabBarVC = TabBarController()
        
        tabBarVC.tabBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        tabBarVC.tabBar.tintColor = .white
        tabBarVC.tabBar.unselectedItemTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)

        
        let mainScreenVC = MainScreenViewController()
        mainScreenVC.title = tabBarVC.mainScreenTitle
                
        let mainScreenInteractor = MainScreenInteractor()
        let mainScreenPresenter = MainScreenPresenter()
        let mainScreenRouter = MainScreenRouter()

        mainScreenInteractor.presenter = mainScreenPresenter

        mainScreenPresenter.view = mainScreenVC
        mainScreenPresenter.interactor = mainScreenInteractor
        mainScreenPresenter.router = mainScreenRouter

        mainScreenVC.presenter = mainScreenPresenter

        
        let settingsVC = SettingsViewController()
        settingsVC.title = tabBarVC.settingsTitle
        
        let settingsInteractor = SettingsInteractor()
        let settingsPresenter = SettingsPresenter()
        let settingsRouter = SettingsRouter()

        settingsInteractor.presenter = settingsPresenter

        settingsPresenter.view = settingsVC
        settingsPresenter.interactor = settingsInteractor
        settingsPresenter.router = settingsRouter

        settingsVC.presenter = settingsPresenter
        
        tabBarVC.setViewControllers([mainScreenVC, settingsVC], animated: true)
        
        let tabBarImagesNames = ["ellipsis", "gearshape.circle.fill"]
        
        guard let items = tabBarVC.tabBar.items else { return }
        
        for (index, item) in items.enumerated() {
            item.image = UIImage(systemName: tabBarImagesNames[index])
        }
        
        tabBarVC.modalPresentationStyle = .fullScreen
        
        changeRootViewController(tabBarVC)
        
        window?.rootViewController = tabBarVC
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        
        window.rootViewController = vc
        
        if animated {
            UIView.transition(with: window,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
        
    }
}

