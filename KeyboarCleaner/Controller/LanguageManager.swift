//
//  LanguageManager.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 1/18/2026.
//

import Foundation
import SwiftUI

class LanguageManager {
    static let shared = LanguageManager()
    
    @AppStorage("selectedLanguage") private var storedLanguage: String?
    
    var availableLanguages: [String] {
        Bundle.main.localizations.filter{ $0 != "en"}
    }
    
    var currentLanguage: String {
        get {
            if let stored = storedLanguage {
                return stored
            }
            let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            if availableLanguages.contains(systemLanguage) {
                return systemLanguage
            }
            return availableLanguages.first ?? "en"
            
        }
        set { storedLanguage = newValue }
    }
    
    func displayName(for languageCode: String) -> String {
        let locale = Locale(identifier: languageCode)
        return locale.localizedString(forIdentifier: languageCode) ?? languageCode
    }
}
