//
//  BackgroundView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 1/16/2026.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [
            .blue,
            .purple,
            .red
        ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
