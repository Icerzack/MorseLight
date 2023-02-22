//
//  LocalizationService.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 21.02.2023.
//

import Foundation

enum AppStrings: String, CaseIterable {
    case mainScreenTitle
    case mainScreenInputAreaHint
    case mainScreenOutputAreaHint
    case mainScreenFlashButtonStart
    case mainScreenFlashButtonStop
    case settingsScreenTitle
    case settingsScreenBlinkingSpeedTitle
    case settingsScreenDotSpeedTitle
    case settingsScreenDashSpeedTitle
    case settingsScreenBlinkingSpeedHint
    case settingsScreenOtherTitle
    case settingsScreenLanguageTitle
    case settingsScreenLanguageLabel
    case settingsScreenAboutButton
    case tabBarConvertButton
    case tabBarSettingsButton
}

protocol LocalizationServiceObserver: AnyObject {
    func didUpdateCurrentLocalization(newLocalizationCollection: [AppStrings:String])
}

//Fix retain cycle
struct WeakLocalizationServiceObserver {
    weak var value: LocalizationServiceObserver?
}

final class LocalizationService {
    
    static let shared = LocalizationService()
    
    private var currentAppStringsCollection: [AppStrings:String] = [:]
    private lazy var observers: [WeakLocalizationServiceObserver] = []
    
    private init() {}
    
    func setupRussianLocalization(){
        for str in AppStrings.allCases {
            switch str {
            case .mainScreenTitle:
                currentAppStringsCollection[str] = "MorseLight  🔦"
            case .mainScreenInputAreaHint:
                currentAppStringsCollection[str] = "Нажмите здесь, чтобы напечатать сообщение"
            case .mainScreenOutputAreaHint:
                currentAppStringsCollection[str] = "Здесь будет результат в коде азбуки Морзе"
            case .mainScreenFlashButtonStart:
                currentAppStringsCollection[str] = "Зажечь! 💡"
            case .mainScreenFlashButtonStop:
                currentAppStringsCollection[str] = "Стоп! ⛔️"
            case .settingsScreenTitle:
                currentAppStringsCollection[str] = "Настройки  ⚙️"
            case .settingsScreenBlinkingSpeedTitle:
                currentAppStringsCollection[str] = "Скорость мигания 👁️:"
            case .settingsScreenDotSpeedTitle:
                currentAppStringsCollection[str] = "Скорость точки (в сек.):"
            case .settingsScreenDashSpeedTitle:
                currentAppStringsCollection[str] = "Скорость тире (в сек.):"
            case .settingsScreenBlinkingSpeedHint:
                currentAppStringsCollection[str] = "ⓘ Согласно правилу азбуки Морзе, длительность тире равна трем точкам."
            case .settingsScreenOtherTitle:
                currentAppStringsCollection[str] = "Прочее ℹ️:"
            case .settingsScreenLanguageTitle:
                currentAppStringsCollection[str] = "Язык:"
            case .settingsScreenLanguageLabel:
                currentAppStringsCollection[str] = "🇷🇺 Русский"
            case .settingsScreenAboutButton:
                currentAppStringsCollection[str] = "О приложении"
            case .tabBarConvertButton:
                currentAppStringsCollection[str] = "Конвертировать"
            case .tabBarSettingsButton:
                currentAppStringsCollection[str] = "Настройки"
            }
        }
        notify()
    }
    
    func setupEnglishLocalization() {
        for str in AppStrings.allCases {
            switch str {
            case .mainScreenTitle:
                currentAppStringsCollection[str] = "MorseLight  🔦"
            case .mainScreenInputAreaHint:
                currentAppStringsCollection[str] = "Tap here to type message"
            case .mainScreenOutputAreaHint:
                currentAppStringsCollection[str] = "Result of your message in Morse code"
            case .mainScreenFlashButtonStart:
                currentAppStringsCollection[str] = "Flash! 💡"
            case .mainScreenFlashButtonStop:
                currentAppStringsCollection[str] = "Stop! ⛔️"
            case .settingsScreenTitle:
                currentAppStringsCollection[str] = "Settings  ⚙️"
            case .settingsScreenBlinkingSpeedTitle:
                currentAppStringsCollection[str] = "Blinking speed 👁️:"
            case .settingsScreenDotSpeedTitle:
                currentAppStringsCollection[str] = "Dot speed (in sec.):"
            case .settingsScreenDashSpeedTitle:
                currentAppStringsCollection[str] = "Dash speed (in sec.):"
            case .settingsScreenBlinkingSpeedHint:
                currentAppStringsCollection[str] = "ⓘ According to the rule of Morse code, a dash is equal to three dots in duration."
            case .settingsScreenOtherTitle:
                currentAppStringsCollection[str] = "Other ℹ️:"
            case .settingsScreenLanguageTitle:
                currentAppStringsCollection[str] = "Language:"
            case .settingsScreenLanguageLabel:
                currentAppStringsCollection[str] = "🇺🇸 English"
            case .settingsScreenAboutButton:
                currentAppStringsCollection[str] = "About"
            case .tabBarConvertButton:
                currentAppStringsCollection[str] = "Convert"
            case .tabBarSettingsButton:
                currentAppStringsCollection[str] = "Settings"
            }
        }
        notify()
    }
    
    func subscribe(_ observer: LocalizationServiceObserver) {
        observers.append(WeakLocalizationServiceObserver(value: observer))
    }
    
    func unsubscribe(_ observer: LocalizationServiceObserver) {
        observers.removeAll(where: { $0.value === observer })
    }
    
    func notify() {
        observers.forEach { $0.value?.didUpdateCurrentLocalization(newLocalizationCollection: currentAppStringsCollection) }
    }
}
