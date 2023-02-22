//
//  MainScreenInteractor.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 20.02.2023.
//

import Foundation

protocol MainScreenInteractorProtocol: AnyObject {
    func convertTextToMorse(textToConvert: String)
    func setDefaultLocalization(withLanguage: Languages)
    func subscribeToLocalization(view: LocalizationServiceObserver)
    func applySavedSettings()
}

final class MainScreenInteractor: MainScreenInteractorProtocol {
    
    weak var presenter: MainScreenPresenterProtocol?
    var morseConverter: MorseConverter?
    
    //Get from Presenter
    func convertTextToMorse(textToConvert: String) {
        morseConverter = MorseConverter()
        let convertedText = morseConverter?.convertToMorse(from: textToConvert) ?? ""
        presenter?.didReceiveConvertedToMorseText(morseText: convertedText)
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
    func applySavedSettings() {
        let savedSettings = SettingsStorage.shared.getSettings()
        let dotSpeed = savedSettings.dotSpeed
        let dashSpeed = savedSettings.dashSpeed
        presenter?.didReceiveSavedSettings(dotSpeed: dotSpeed, dashSpeed: dashSpeed)
    }
}
