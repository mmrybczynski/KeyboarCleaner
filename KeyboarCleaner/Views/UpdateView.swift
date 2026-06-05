//
//  UpdateView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 6/5/2026.
//

import SwiftUI

struct UpdateView: View {
    @StateObject private var updateManager = UpdateManager()
    
    var body: some View {
        VStack {
            Button("Sprawdź aktualizacje") {
                Task {
                    let success = await updateManager.checkForUpdates()
                    print("Sukces: \(success)")
                }
            }
        }
    }
}

#Preview {
    UpdateView()
}
