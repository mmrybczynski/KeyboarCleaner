//
//  SettingsView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 31/05/2026.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("selectedLanguage") private var selectedLanguageCode: String?
    @State private var showLanguageMenu = false
    
    private var languageManager: LanguageManager { .shared }
    private var availableLanguageCodes: [String] {
        // Upewnij się, że mamy też angielski; Bundle bywa z "Base"
        var codes = languageManager.availableLanguages
        if !codes.contains("en") { codes.insert("en", at: 0) }
        // Usuń ewentualne "Base"
        return codes.filter { $0.lowercased() != "base" }
    }
    private func displayName(for code: String) -> String {
        languageManager.displayName(for: code)
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Image("menuExtraBar")
                Image("menuExtraBarHover")
            }
            
            Menu {
                // Pokaż aktualny wybór jako nagłówek (nieklikalny)
                let current = selectedLanguageCode ?? availableLanguageCodes.first ?? "en"
                Label("\(displayName(for: current))", systemImage: "checkmark")
                    .foregroundStyle(.secondary)
                Divider()
                // Lista wszystkich dostępnych języków bez aktualnego
                ForEach(availableLanguageCodes.filter { $0 != current }, id: \.self) { code in
                    Button {
                        selectedLanguageCode = code
                    } label: {
                        Text(displayName(for: code))
                    }
                }
            } label: {
                Label(displayName(for: selectedLanguageCode ?? availableLanguageCodes.first ?? "en"), systemImage: "globe")
            }
            .help("Zmień język")
        }
        .frame(width: 400, height: 400)
        .environment(\.locale, Locale(identifier: selectedLanguageCode ?? Locale.current.language.languageCode?.identifier ?? "en"))
        .background(Color.gray.opacity(0.2))
        .navigationTitle("settings")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Link(destination: URL(string: "https://www.m-rybczynski.com")!) {
                    HStack {
                        Image(systemName: "link")
                        Text("czytajWiecej")
                    }
                    .padding(.horizontal)
                    
                }
                .help("Sprawdź")
            }
        }
    }
}

#Preview {
    SettingsView()
}
