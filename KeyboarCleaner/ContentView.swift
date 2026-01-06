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
        VStack(spacing: 10) {
            
            
            Toggle(isOn: Binding(get: {blocker.isBlocking},
                                 set: {newValue in
                         if newValue {blocker.startBlocking()
                         } else {
                             blocker.stopBlocking()
                         }})) {
                             HStack {
                                 Text("Włącz try czyszczenia klawiatury")
                                 Spacer()
                             }
            }.toggleStyle(SwitchToggleStyle(tint: .blue))
            
            VStack {
                Image(systemName: blocker.isBlocking ? "keyboard.fill" : "keyboard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(blocker.isBlocking ? .red : .green)
                    .symbolEffect(.bounce, value: blocker.isBlocking)
                Text(blocker.isBlocking ? "Klawiatura nie aktywna" : "Klawiatura aktywna")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(blocker.isBlocking ? .red : .green)
            }
            
            /*Text("Gdy tryb jest aktywny, klawiatura jest wyłączona.\nUżyj myszki/gładzika, aby wyłączyć blokadę.")
                .multilineTextAlignment(.center)
                .font(.caption)
            
            Button {
                if blocker.isBlocking {
                    blocker.stopBlocking()
                } else {
                    blocker.startBlocking()
                }
            } label: {
                Text(blocker.isBlocking ? "Włącz klawiaturę" : "Zablokuj klawiaturę")
                    .font(.headline)
                    .padding()
                    .frame(width: 200)
                    .background(blocker.isBlocking ? Color.green : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .buttonStyle(.plain)*/

        }
        .padding(50)
        .frame(minWidth: 200, maxWidth: 400, minHeight: 150, maxHeight: 200)
    }
}

#Preview {
    ContentView()
}
