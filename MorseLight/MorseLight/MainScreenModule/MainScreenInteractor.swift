//
//  MainScreenInteractor.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 20.02.2023.
//

import Foundation

protocol MainScreenInteractorProtocol: AnyObject {
    func convertTextToMorse(textToConvert: String)
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
}
