//
//  AppIconTile.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 6/2/2026.
//

import SwiftUI

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
                Image(iconName)
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

#Preview {
    SettingsView()
}
