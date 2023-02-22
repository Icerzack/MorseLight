//
//  TabBarController.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 20.02.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    var mainScreenTitle = "" {
        didSet {
            viewControllers?.forEach({ vc in
                if vc is MainScreenViewController {
                    vc.title = mainScreenTitle
                }
            })
        }
    }
    var settingsTitle = "" {
        didSet {
            viewControllers?.forEach({ vc in
                if vc is SettingsViewController {
                    vc.title = settingsTitle
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocalizationService.shared.subscribe(self)
        
        if UserDefaults.standard.object(forKey: UserDefaults.settingsLanguageKey) == nil {
            LocalizationService.shared.setupEnglishLocalization()
            UserDefaults.standard.setValue(Languages.english.rawValue, forKey: UserDefaults.settingsLanguageKey)
        } else {
            switch UserDefaults.standard.object(forKey: UserDefaults.settingsLanguageKey) as? String {
            case Languages.english.rawValue:
                LocalizationService.shared.setupEnglishLocalization()
            case Languages.russian.rawValue:
                LocalizationService.shared.setupRussianLocalization()
            case .none:
                break
            case .some(_):
                break
            }
        }
        
        delegate = self
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}

extension TabBarController: LocalizationServiceObserver {
    func didUpdateCurrentLocalization(newLocalizationCollection: [AppStrings : String]) {
        mainScreenTitle = newLocalizationCollection[.tabBarConvertButton] ?? "Convert"
        settingsTitle = newLocalizationCollection[.tabBarSettingsButton] ?? "Settings"
    }
    
}
