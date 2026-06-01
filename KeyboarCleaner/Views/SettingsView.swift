//
//  SettingsView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 31/05/2026.
//

import SwiftUI

enum SettingsTab: String, CaseIterable, Identifiable {
    case general = "General"
    case updates = "Updates"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .general: return "gearshape"
        case .updates: return "arrow.clockwise.circle"
        }
    }
}

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
    
    @State private var selectedTab: SettingsTab? = .general
    
    var body: some View {
        /*VStack {
            
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
        }*/
        
        NavigationView {
            VStack {
                Text("Settings")
                
                List {
                    ForEach(SettingsTab.allCases) { tab in
                        Button(action: {
                            selectedTab = tab
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: tab.iconName)
                                    .font(.system(size: 14))
                                    .frame(width: 18, alignment: .center)
                                    .foregroundColor(selectedTab == tab ? .blue : .primary.opacity(0.8))
                                
                                Text(tab.rawValue)
                                    .font(.system(size: 13))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(SidebarButtonStyle(isSelected: selectedTab == tab))
                    }
                }
                .listStyle(SidebarListStyle())
                
                Spacer()
                
                VStack(spacing: 0) {
                    Divider()
                    HStack(spacing: 12) {
                        // Logo aplikacji oparte na SF Symbols
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 18))
                            .frame(width: 32, height: 32)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("KeyClean")
                                .font(.system(size: 13, weight: .bold))
                            Text("Version 2.4.0 (Stable Build)")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(BlurView(material: .sidebar, blendingMode: .withinWindow))
                }
            }
            .frame(minWidth: 200, idealWidth: 220, maxWidth: 240)
            
            DynamicContentView(selectedTab: selectedTab!)
            
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    struct SidebarButtonStyle: ButtonStyle {
        let isSelected: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isSelected ? Color.blue.opacity(0.12) : (configuration.isPressed ? Color.primary.opacity(0.05) : Color.clear))
                )
                .foregroundColor(isSelected ? .blue : .primary)
                .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
        }
    }
    
    struct BlurView: NSViewRepresentable {
        let material: NSVisualEffectView.Material
        let blendingMode: NSVisualEffectView.BlendingMode
        
        func makeNSView(context: Context) -> NSVisualEffectView {
            let visualEffectView = NSVisualEffectView()
            visualEffectView.material = material
            visualEffectView.blendingMode = blendingMode
            visualEffectView.state = .active
            return visualEffectView
        }
        
        func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
            nsView.material = material
            nsView.blendingMode = blendingMode
        }
    }
    
    struct DynamicContentView: View {
        let selectedTab: SettingsTab
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                // Nagłówek widoku głównego, dopasowany do makiety
                HStack {
                    Text(selectedTab.rawValue)
                        .font(.system(size: 22, weight: .semibold))
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 12)
                
                Divider()
                
                // Wyświetlanie właściwego widoku w zależności od wyboru
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        switch selectedTab {
                        case .general:
                            GeneralSettingsContentView()
                        case .updates:
                            Text("Advanced Preferences").foregroundColor(.secondary)
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .background(Color(.windowBackgroundColor))
        }
    }
    
    struct GeneralSettingsContentView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                
                // Sekcja: App Icon
                VStack(alignment: .leading, spacing: 12) {
                    Text("App Icon")
                        .font(.system(size: 14, weight: .bold))
                    
                    HStack(spacing: 14) {
                        AppIconTile(iconName: "keyboard", title: "Classic Blue", isSelected: true)
                        AppIconTile(iconName: "keyboard.onehanded.left", title: "Midnight", isSelected: false)
                        AppIconTile(iconName: "square.grid.3x1.below.line.grid.1x2", title: "Prism", isSelected: false)
                        AppIconTile(iconName: "macmini", title: "Tech", isSelected: false)
                    }
                }
                
                // Sekcja: Language
                VStack(alignment: .leading, spacing: 10) {
                    Text("Language")
                        .font(.system(size: 14, weight: .bold))
                    
                    HStack(spacing: 12) {
                        Image(systemName: "globe")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Interface Language")
                                .font(.system(size: 13, weight: .medium))
                            Text("Select your preferred language for the app interface")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Picker("", selection: .constant("en")) {
                            Text("English (US)").tag("en")
                            Text("Polski").tag("pl")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 140)
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
    }
    
    struct AppIconTile: View {
        let iconName: String
        let title: String
        let isSelected: Bool
        
        var body: some View {
            VStack(spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    // Tło podglądu ikony
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.primary.opacity(0.04))
                        .frame(width: 84, height: 84)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(isSelected ? Color.blue : Color.primary.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                        )
                    
                    // Miniatura SF Symbol wewnątrz kafelka
                    Image(systemName: iconName)
                        .font(.system(size: 32))
                        .foregroundColor(isSelected ? .blue : .primary.opacity(0.7))
                        .frame(width: 84, height: 84)
                    
                    // Znacznik wyboru (Checkmark) z obrazka referencyjnego
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                            .background(Color.white.clipShape(Circle()))
                            .font(.system(size: 16))
                            .padding(.top, -4)
                            .padding(.trailing, -4)
                    }
                }
                
                Text(title)
                    .font(.system(size: 11, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? .blue : .primary)
            }
        }
    }
    
    
}

#Preview {
    SettingsView()
}
