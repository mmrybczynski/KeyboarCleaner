//
//  GeneralSettingsContentView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 6/2/2026.
//

import SwiftUI

struct GeneralSettingsContentView: View {
    @AppStorage("selectedIcon") private var selectedIcon: String = "menuExtraBar"
    
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
        VStack(alignment: .leading, spacing: 24) {
            
            // Sekcja: App Icon
            VStack(alignment: .leading, spacing: 12) {
                Text("appicon")
                    .font(.system(size: 14, weight: .bold))
                
                HStack(spacing: 14) {
                    AppIconTile(iconName: "menuExtraBarBig", title: "Classic Blue", isSelected: selectedIcon == "menuExtraBar")
                        .onTapGesture {
                            selectedIcon = "menuExtraBar"
                        }
                    AppIconTile(iconName: "menuExtraBarHoverBig", title: "Midnight", isSelected: selectedIcon == "menuExtraBarHover")
                        .onTapGesture {
                            selectedIcon = "menuExtraBarHover"
                        }
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Button {
                            openAccessibilityPreferences()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "hand.tap")
                                Text("accesibilityLaabel")
                            }
                        }
                        .buttonStyle(.link)
                        .padding(.bottom, 8)
                        
                        Button {
                                openInputMonitoringPreferences()
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "keyboard")
                                    Text("inputMonitoringLabel")
                                }
                            }
                            .buttonStyle(.link)
                            .padding(.bottom, 8)
                    }
                
                    
                    
                    Spacer()
                }
                .padding(.all, 14)
                .background(Color.primary.opacity(0.03))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary.opacity(0.06), lineWidth: 1)
                )
                
            }
            
            // Sekcja: Language
            VStack(alignment: .leading, spacing: 10) {
                Text("language")
                    .font(.system(size: 14, weight: .bold))
                
                HStack(spacing: 12) {
                    Image(systemName: "globe")
                        .font(.system(size: 18))
                        .foregroundColor(.blue)
                        .frame(width: 24, height: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("interface")
                            .font(.system(size: 13, weight: .medium))
                        Text("select")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
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
                .padding(.all, 14)
                .background(Color.primary.opacity(0.03))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary.opacity(0.06), lineWidth: 1)
                )
            }
        }
    }
    
    
    private func openAccessibilityPreferences() {
        // Works on macOS Ventura and newer System Settings
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
            return
        }
        // Fallback for older macOS (System Preferences)
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }
    
    private func openInputMonitoringPreferences() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent") {
            NSWorkspace.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
}
