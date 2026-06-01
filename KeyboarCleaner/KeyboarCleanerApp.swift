//
//  KeyboarCleanerApp.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 12/4/2025.
//

import SwiftUI

@main
struct KeyboarCleanerApp: App {
    @AppStorage("selectedLanguage") private var selectedLanguageCode: String?
    
    @AppStorage("selectedIcon") private var selectedIcon: String = "menuExtraBar"
    
    @StateObject private var blocker = KeyboardBlocker()

    var body: some Scene {
        MenuBarExtra("Keyboard cleaner", image: selectedIcon) {
            ContentView()
                .environmentObject(blocker)
                .environment(\.locale, Locale(identifier: activeLanguage))
        }
        .menuBarExtraStyle(.window)
        
        Window("Settings", id: "settings") {
           SettingsView()
                .environment(\.locale, Locale(identifier: activeLanguage))
        }
        .defaultSize(width: 600, height: 400)
    }
    
    var activeLanguage: String {
        if let selected = selectedLanguageCode {
            return selected
        }
        // Fallback do systemu, jeśli nic nie wybrano
        let systemLang = Locale.current.language.languageCode?.identifier ?? "en"
        let available = Bundle.main.localizations
        return available.contains(systemLang) ? systemLang : (available.first ?? "en")
    }
    
}
