//
//  BackgroundView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 1/16/2026.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            
            Color.black
            
            LinearGradient(gradient: Gradient(colors: [
                .pink.opacity(0.2),
                .blue.opacity(0.5)
            ]), startPoint: .top, endPoint: .bottom)
        }
        .ignoresSafeArea()
        
           
    }
}

#Preview {
    BackgroundView()
}
