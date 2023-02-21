//
//  MainScreenPresenter.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 20.02.2023.
//

import Foundation

protocol MainScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didChangeTextField(newText: String)
    func didReceiveConvertedToMorseText(morseText: String)
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    
    var interactor: MainScreenInteractorProtocol?
    var router: MainScreenRouterProtocol?
    weak var view: MainScreenViewProtocol?
    
    func viewDidLoad() {
        //any setup
    }
    
    //Get from View -> Send to Interactor
    func didChangeTextField(newText: String) {
        interactor?.convertTextToMorse(textToConvert: newText)
    }
    
    //Get from Interactor -> Send to View
    func didReceiveConvertedToMorseText(morseText: String){
        view?.displayConvertedToMorseText(textToDisplay: morseText)
    }
}

