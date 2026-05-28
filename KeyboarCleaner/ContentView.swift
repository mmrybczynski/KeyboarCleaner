//
//  ContentView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 12/4/2025.
//

import SwiftUI
import ServiceManagement

struct ContentView: View {
    @EnvironmentObject var blocker: KeyboardBlocker
    
    @State var keyboardActive: Color = .red
    @State var keyboardInactive: Color = .white
    
    @State private var launchAtLogin = false
    
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
            
            Toggle(
                "Launch at login",
                isOn: $launchAtLogin
            )
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
        }
        .padding()
        .frame(width: 250)
        .padding()
        
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
