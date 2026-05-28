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
    @StateObject private var blocker = KeyboardBlocker()
    var body: some Scene {
        /*WindowGroup {
            ContentView()
                .environmentObject(blocker)
        }
        .windowResizability(.contentSize)*/

        MenuBarExtra("Keyboard cleaner", systemImage: "keyboard") {
            ContentView()
                .environmentObject(blocker)
        }
        .windowResizability(.contentSize)
    }
    
    var activeLanguage: String {
        if let selected = selectedLanguageCode {
            return selected
        }
        // Fallback do systemu, jeśli nic nie wybrano
        let systemLang = Locale.current.language.languageCode?.identifier ?? "pl"
        let available = Bundle.main.localizations
        return available.contains(systemLang) ? systemLang : (available.first ?? "pl")
    }
    
}
