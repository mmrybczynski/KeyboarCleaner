//
//  DynamicContentView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 6/2/2026.
//

import SwiftUI

struct DynamicContentView: View {
    let selectedTab: SettingsTab
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Nagłówek widoku głównego, dopasowany do makiety
            HStack {
                Text(LocalizedStringKey(selectedTab.rawValue))
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
                        Text(LocalizedStringKey("updates")).foregroundColor(.secondary)
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        //.background(Color(.windowBackgroundColor))
    }
}

#Preview {
    SettingsView()
}
