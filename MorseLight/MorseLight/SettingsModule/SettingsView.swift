//
//  SettingsViewController.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 20.02.2023.
//

import UIKit

protocol SettingsViewInput: AnyObject {
    func performFlashlightAction(morseText: String)
}

protocol SettingsViewOutput {
    func writtenTextToTranslate(textToTranslate: String)
}

class SettingsViewController: UIViewController, SettingsViewInput {
    
    var output: MainScreenViewProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 4, green: 7, blue: 46)
    }

    func performFlashlightAction(morseText: String) {
        
    }
    
}
