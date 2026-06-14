//
//  ContentView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 12/4/2025.
//

import SwiftUI
import ServiceManagement

struct ContentView: View {
    @AppStorage("selectedLanguage") private var selectedLanguageCode: String?
    @State private var showLanguageMenu = false
    
    @EnvironmentObject var blocker: KeyboardBlocker
    
    @State var keyboardActive: Color = .red
    @State var keyboardInactive: Color = .white
    
    @State private var launchAtLogin = false
    
    private var languageManager: LanguageManager { .shared }
    private var availableLanguageCodes: [String] {
        var codes = languageManager.availableLanguages
        if !codes.contains("en") { codes.insert("en", at: 0) }
        return codes.filter { $0.lowercased() != "base" }
    }
    private func displayName(for code: String) -> String {
        languageManager.displayName(for: code)
    }
    
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        VStack {
            Toggle(isOn: Binding(get: {blocker.isBlocking},
                                 set: {newValue in
                         if newValue {blocker.startBlocking()
                         } else {
                             blocker.stopBlocking()
                         }})) {
                             HStack {
                                 Text("keyboardButton")
                                     .fontWeight(.bold)
                                 Spacer()
                             }
            }.toggleStyle(SwitchToggleStyle(tint: .blue))
            
            Toggle(isOn: $launchAtLogin) {
                HStack {
                    Text("launchAtLogin")
                    Spacer()
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .onChange(of: launchAtLogin) { oldValue, newValue in
                do {
                    if newValue {
                        try SMAppService.mainApp.register()
                    } else {
                        try SMAppService.mainApp.unregister()
                    }
                } catch {
                    print(error)
                }
            }
            .onAppear {
                launchAtLogin = SMAppService.mainApp.status == .enabled
            }
            
            Divider()
            HStack {
                
                
                Button("quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.plain)
                .foregroundColor(.primary)
                
                Spacer()
                
                Button("settings") {
                    openWindow(id: "settings")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        if let window = NSApp.windows.first(where: { $0.identifier?.rawValue == "settings" }) {
                            window.level = .floating
                            window.makeKeyAndOrderFront(nil)
                            NSApp.activate(ignoringOtherApps: true)
                        }
                    }
                }
            }
            
        }
        .padding()
        .frame(width: 350)
        
    }
}

#Preview {
    ContentView()
        .environmentObject(KeyboardBlocker())
}

