//
//  SettingInteractor.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 21.02.2023.
//

import Foundation

protocol SettingsInteractorProtocol {
    func updateLocalization(requestedLanguage: Languages)
    func setDefaultLocalization(withLanguage: Languages)
    func saveAllSettings(settings: Settings)
    func subscribeToLocalization(view: LocalizationServiceObserver)
    func applySavedSettings()
}

final class SettingsInteractor: SettingsInteractorProtocol {
    
    weak var presenter: SettingsPresenterProtocol?
    var morseConverter: MorseConverter?
    
    //Get from Presenter
    func updateLocalization(requestedLanguage: Languages) {
        switch requestedLanguage {
        case .russian:
            LocalizationService.shared.setupRussianLocalization()
            presenter?.didReceiveNewLanguage(result: .success("Russian set"))
        case .english:
            LocalizationService.shared.setupEnglishLocalization()
            presenter?.didReceiveNewLanguage(result: .success("English set"))
        default:
            presenter?.didReceiveNewLanguage(result: .failure(LanguageErrors.noSuchLanguageError))
        }
    }
    
    //Get from Presenter
    func setDefaultLocalization(withLanguage: Languages) {
        switch withLanguage {
        case .english:
            LocalizationService.shared.setupEnglishLocalization()
            presenter?.didReceiveDefaultLocalizationSetupResult(result: .success("English"))
        case .russian:
            LocalizationService.shared.setupRussianLocalization()
            presenter?.didReceiveDefaultLocalizationSetupResult(result: .success("Russian"))
        }
    }
    
    //Get from Presenter
    func subscribeToLocalization(view: LocalizationServiceObserver) {
        LocalizationService.shared.subscribe(view)
        LocalizationService.shared.notify()
    }
    
    //Get from Presenter
    func saveAllSettings(settings: Settings) {
        SettingsStorage.shared.saveSettings(newSettings: settings)
    }
    
    //Get from Presenter
    func applySavedSettings() {
        let savedSettings = SettingsStorage.shared.getSettings()
        presenter?.didReceiveSavedSettings(receivedSettings: savedSettings)
    }
}
