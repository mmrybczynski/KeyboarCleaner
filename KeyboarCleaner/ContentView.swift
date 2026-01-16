//
//  ContentView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 12/4/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var blocker = KeyboardBlocker()
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            VStack(spacing: 10) {
                
                
                Toggle(isOn: Binding(get: {blocker.isBlocking},
                                     set: {newValue in
                             if newValue {blocker.startBlocking()
                             } else {
                                 blocker.stopBlocking()
                             }})) {
                                 HStack {
                                     Text(.clearButtonOn)
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
                        .foregroundColor(blocker.isBlocking ? .red : .white)
                        .symbolEffect(.bounce, value: blocker.isBlocking)
                    
                    Text(blocker.isBlocking ? .keyboardDisabled : .keyboardEnabled)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(blocker.isBlocking ? .red : .white)
                    
                    Spacer()
                }

            }
            .padding(50)
            
            .navigationTitle("Keyboard Cleaner")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Link(destination: URL(string: "https://www.m-rybczynski.com")!) {
                        HStack {
                            Image(systemName: "link")
                            Text(.readMore)
                        }
                        .padding(.horizontal)
                        
                    }
                    .help(.helpWeb)
                }
            }
        }
        .frame(width: 400, height: 200)
        
        
        
        
    }
}

#Preview {
    ContentView()
}
