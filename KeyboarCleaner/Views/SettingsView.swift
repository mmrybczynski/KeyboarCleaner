//
//  SettingsView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 31/05/2026.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("selectedLanguage") private var selectedLanguageCode: String?
    @AppStorage("selectedIcon") private var selectedIcon: String = "menuExtraBar"
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
            
            HStack(spacing: 12) {
                let icon1 = "menuExtraBar"
                let icon2 = "menuExtraBarHover"

                Image(icon1)
                    .resizable()
                    .interpolation(.high)
                    .antialiased(true)
                    .renderingMode(.original)
                    .frame(width: 56 ,height: 56)
                    .scaledToFit()
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedIcon == icon1 ? Color.accentColor.opacity(0.15) : Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedIcon == icon1 ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: selectedIcon == icon1 ? 2 : 1)
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedIcon = icon1
                    }
                    .accessibilityAddTraits(selectedIcon == icon1 ? .isSelected : [])
                    .accessibilityLabel(Text("menuExtraBar"))

                Image(icon2)
                    .resizable()
                    .interpolation(.high)
                    .antialiased(true)
                    .renderingMode(.original)
                    .frame(width: 56 ,height: 56)
                    .scaledToFit()
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedIcon == icon2 ? Color.accentColor.opacity(0.15) : Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedIcon == icon2 ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: selectedIcon == icon2 ? 2 : 1)
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedIcon = icon2
                    }
                    .accessibilityAddTraits(selectedIcon == icon2 ? .isSelected : [])
                    .accessibilityLabel(Text("menuExtraBarHover"))
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
        .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.2))
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
