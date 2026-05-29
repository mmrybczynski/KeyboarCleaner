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
        // Upewnij się, że mamy też angielski; Bundle bywa z "Base"
        var codes = languageManager.availableLanguages
        if !codes.contains("en") { codes.insert("en", at: 0) }
        // Usuń ewentualne "Base"
        return codes.filter { $0.lowercased() != "en" }
    }
    private func displayName(for code: String) -> String {
        languageManager.displayName(for: code)
    }
    
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
                                     .foregroundStyle(Color(.black))
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
            .onChange(of: launchAtLogin) { enabled in

                do {

                    if enabled {
                        try SMAppService.mainApp.register()
                    } else {
                        try SMAppService.mainApp.unregister()
                    }

                } catch {
                    print(error)
                }
            }
            .onAppear {

                launchAtLogin =
                    SMAppService.mainApp.status == .enabled
            }
            
            Divider()
            HStack {
                
                
                Button("quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.plain)
                .foregroundColor(.primary)
                
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
            
        }
        .padding()
        .frame(width: 250)
        
        /*ZStack {
            BackgroundView()
            
            VStack(spacing: 10) {
                
                
                Toggle(isOn: Binding(get: {blocker.isBlocking},
                                     set: {newValue in
                             if newValue {blocker.startBlocking()
                             } else {
                                 blocker.stopBlocking()
                             }})) {
                                 HStack {
                                     Text("keyboardButton")
                                         .fontWeight(.bold)
                                         .foregroundStyle(Color(.white))
                                     Spacer()
                                 }
                }.toggleStyle(SwitchToggleStyle(tint: .blue))
                
                HStack {
                    Image(systemName: blocker.isBlocking ? "keyboard.fill" : "keyboard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 70)
                        .foregroundColor(blocker.isBlocking ? keyboardActive : keyboardInactive)
                        .symbolEffect(.bounce, value: blocker.isBlocking)
                    
                    Text(blocker.isBlocking ? "klawiaturaON" : "klawiaturaOFF")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(blocker.isBlocking ? keyboardActive : keyboardInactive)
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Image(systemName: "globe")
                    Text("language")
                }

            }
            .padding(50)
            
            .navigationTitle("Keyboard Cleaner")
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
        .frame(width: 400, height: 200)*/
        
    }
}

#Preview {
    ContentView()
        .environmentObject(KeyboardBlocker())
}
