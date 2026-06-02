//
//  SettingsView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 31/05/2026.
//

import SwiftUI

enum SettingsTab: String, CaseIterable, Identifiable {
    case general = "general"
    case updates = "updates"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .general: return "gearshape"
        case .updates: return "arrow.clockwise.circle"
        }
    }
}

struct SettingsView: View {

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
                Text("settings")
                
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
                                
                                Text(LocalizedStringKey(tab.rawValue))
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
            .frame(minWidth: 220, idealWidth: 220, maxWidth: 220)
            
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
    
    
    
    
}

#Preview {
    SettingsView()
}
