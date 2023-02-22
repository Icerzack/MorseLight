//
//  SettingsEntity.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 21.02.2023.
//

import Foundation

struct Settings {
    var dotSpeed: Float
    var dashSpeed: Float
    var language: Languages
}

enum Languages: String {
    case russian
    case english
}

enum LanguageErrors: Error {
    case noSuchLanguageError
}
