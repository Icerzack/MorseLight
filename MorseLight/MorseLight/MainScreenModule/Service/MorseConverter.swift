//
//  MorseConverter.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 21.02.2023.
//

import Foundation

class MorseConverter {
    
    private let alphaNumToMorse = [
        "A": ".-",
        "B": "-...",
        "C": "-.-.",
        "D": "-..",
        "E": ".",
        "F": "..-.",
        "G": "--.",
        "H": "....",
        "I": "..",
        "J": ".---",
        "K": "-.-",
        "L": ".-..",
        "M": "--",
        "N": "-.",
        "O": "---",
        "P": ".--.",
        "Q": "--.-",
        "R": ".-.",
        "S": "...",
        "T": "-",
        "U": "..-",
        "V": "...-",
        "W": ".--",
        "X": "-..-",
        "Y": "-.--",
        "Z": "--..",
        "a": ".-",
        "b": "-...",
        "c": "-.-.",
        "d": "-..",
        "e": ".",
        "f": "..-.",
        "g": "--.",
        "h": "....",
        "i": "..",
        "j": ".---",
        "k": "-.-",
        "l": ".-..",
        "m": "--",
        "n": "-.",
        "o": "---",
        "p": ".--.",
        "q": "--.-",
        "r": ".-.",
        "s": "...",
        "t": "-",
        "u": "..-",
        "v": "...-",
        "w": ".--",
        "x": "-..-",
        "y": "-.--",
        "z": "--..",
        "1": ".----",
        "2": "..---",
        "3": "...--",
        "4": "....-",
        "5": ".....",
        "6": "-....",
        "7": "--...",
        "8": "---..",
        "9": "----.",
        "0": "-----",
        " ": " ",
    ]
    
    // Conversion
    private func convertLetterToMorse(_ input: Character) -> String {
        var returnChar = alphaNumToMorse[String(input)]
        if returnChar == nil {
            returnChar = ""
        }
        return returnChar!
    }
    
    func convertToMorse(from: String) -> String{
        let charsInString = Array(from)
        var returnString = ""
        for char in charsInString {
            let returnChar = convertLetterToMorse(char)
            if returnChar != "" {
                returnString += returnChar + " "
            }
        }
        return returnString
    }
}
