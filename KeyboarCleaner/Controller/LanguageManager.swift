//
//  LanguageManager.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 1/18/2026.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @AppStorage("selectedLanguage") private var storedLanguage: String?
    
    var availableLanguages: [String] {
        Bundle.main.localizations.filter{ $0 != "pl"}
    }
    
    var currentLanguage: String {
        get {
            if let stored = storedLanguage {
                return stored
            }
            let systemLanguage = Locale.current.language.languageCode?.identifier ?? "pl"
            if availableLanguages.contains(systemLanguage) {
                return systemLanguage
            }
            return availableLanguages.first ?? "pl"
            
        }
        set { storedLanguage = newValue }
    }
    
    func displayName(for languageCode: String) -> String {
        let locale = Locale(identifier: languageCode)
        return locale.localizedString(forIdentifier: languageCode) ?? languageCode
    }
}
