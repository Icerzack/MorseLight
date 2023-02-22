//
//  MainScreenPresenter.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 20.02.2023.
//

import Foundation

protocol MainScreenPresenterProtocol: AnyObject {
    //View methods
    func viewDidLoad()
    func viewDidAppear()
    func didChangeTextField(newText: String)
    
    //Interactor methods
    func didReceiveConvertedToMorseText(morseText: String)
    func didReceiveDefaultLocalizationSetupResult(result: Result<String, Error>)
    func didReceiveSavedSettings(dotSpeed: Float, dashSpeed: Float)
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    
    var interactor: MainScreenInteractorProtocol?
    var router: MainScreenRouterProtocol?
    weak var view: MainScreenViewProtocol?
    
    //Get from View -> Send to Interactor
    func viewDidLoad() {
        interactor?.subscribeToLocalization(view: view as! LocalizationServiceObserver)
    }
    
    //Get from View -> Send to Interactor
    func viewDidAppear() {
        interactor?.applySavedSettings()
    }
    
    //Get from View -> Send to Interactor
    func didChangeTextField(newText: String) {
        interactor?.convertTextToMorse(textToConvert: newText)
    }
    
    //Get from Interactor -> Send to View
    func didReceiveConvertedToMorseText(morseText: String){
        view?.displayConvertedToMorseText(textToDisplay: morseText)
    }
    
    //Get from Interactor -> Send to View
    func didReceiveDefaultLocalizationSetupResult(result: Result<String, Error>) {
        view?.didReceiveDefaultLocalizationSetupResult(result: result)
    }
    
    //Get from Interactor -> Send to View
    func didReceiveSavedSettings(dotSpeed: Float, dashSpeed: Float) {
        view?.didReceiveSavedSettings(dotSpeed: dotSpeed, dashSpeed: dashSpeed)
    }
}

