//
//  SettingsPresenter.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 21.02.2023.
//

import Foundation

protocol SettingsPresenterProtocol: AnyObject {
    //View methods
    func viewDidLoad()
    func viewDidAppear()
    func didTapLanguageLabel(requestedLanguage: Languages)
    func setupDefaultLanguage(requestedLanguage: Languages)
    func didRequestToSaveAllChanges(newSettings: Settings)

    //Interactor methods
    func didReceiveNewLanguage(result: Result<String, Error>)
    func didReceiveDefaultLocalizationSetupResult(result: Result<String, Error>)
    func didReceiveSavedSettings(receivedSettings: Settings)

}

final class SettingsPresenter: SettingsPresenterProtocol {

    var interactor: SettingsInteractorProtocol?
    var router: SettingsRouterProtocol?
    weak var view: SettingsViewProtocol?
    
    //Get from View -> Send to Interactor
    func viewDidLoad() {
        interactor?.subscribeToLocalization(view: view as! LocalizationServiceObserver)
    }
    
    //Get from View -> Send to Interactor
    func viewDidAppear() {
        interactor?.applySavedSettings()
    }
    
    //Get from View -> Send to Interactor
    func didTapLanguageLabel(requestedLanguage: Languages) {
        interactor?.updateLocalization(requestedLanguage: requestedLanguage)
    }
    
    //Get from View -> Send to Interactor
    func setupDefaultLanguage(requestedLanguage: Languages) {
        interactor?.setDefaultLocalization(withLanguage: requestedLanguage)
    }
    
    //Get from View -> Send to Interactor
    func didRequestToSaveAllChanges(newSettings: Settings) {
        interactor?.saveAllSettings(settings: newSettings)
    }
    
    //Get from Interactor -> Send to View
    func didReceiveNewLanguage(result: Result<String, Error>) {
        switch result{
        case .success(let successString):
            view?.didSetupLanguage(result: .success(successString))
        case .failure(let error):
            view?.didSetupLanguage(result: .failure(error))
        }
    }
    
    //Get from Interactor -> Send to View
    func didReceiveDefaultLocalizationSetupResult(result: Result<String, Error>) {
        view?.didReceiveDefaultLocalizationSetupResult(result: result)
    }
    
    //Get from Interactor -> Send to View
    func didReceiveSavedSettings(receivedSettings: Settings) {
        view?.didReceiveSavedSettings(settings: receivedSettings)
    }
}
