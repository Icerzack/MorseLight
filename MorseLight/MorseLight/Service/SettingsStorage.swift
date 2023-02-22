//
//  SettingsStorage.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 21.02.2023.
//

import Foundation

final class SettingsStorage {
    
    static let shared = SettingsStorage()
    
    func saveSettings(newSettings: Settings){
        UserDefaults.standard.set(newSettings.dotSpeed, forKey: UserDefaults.settingsDotSpeedKey)
        UserDefaults.standard.set(newSettings.dashSpeed, forKey: UserDefaults.settingsDashSpeedKey)
        UserDefaults.standard.set(newSettings.language.rawValue, forKey: UserDefaults.settingsLanguageKey)
    }
    
    func getSettings() -> Settings {
        let dotSpeed = UserDefaults.standard.object(forKey: UserDefaults.settingsDotSpeedKey) as? Float
        let dashSpeed = UserDefaults.standard.object(forKey: UserDefaults.settingsDashSpeedKey) as? Float
        let languageString = UserDefaults.standard.object(forKey: UserDefaults.settingsLanguageKey) as? String
        var language: Languages? = nil
        
        switch languageString {
        case Languages.english.rawValue:
            language = .english
        case Languages.russian.rawValue:
            language = .russian
        case .none:
            break
        case .some(_):
            break
        }
        return Settings(dotSpeed: dotSpeed ?? 0.2, dashSpeed: dashSpeed ?? 0.6, language: language ?? .english)
    }
    
    private init() {}
}
