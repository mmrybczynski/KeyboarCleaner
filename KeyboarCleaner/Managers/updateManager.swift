//
//  updateManager.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 6/3/2026.
//

import Foundation
internal import Combine

struct AppConfig: Codable {
    let appVersion: String
}

class UpdateManager: ObservableObject {
    @Published var appVersion: String = ""
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    func checkForUpdates() async -> Bool {
        guard let url = URL(string: "https://www.m-rybczynski.com/applications/keyclean/main.json") else {
            return false
        }
        
        do {
            let(data, _) = try await URLSession.shared.data(from: url)
            let config = try JSONDecoder().decode(AppConfig.self, from: data)
            
            await MainActor.run {
                self.appVersion = config.appVersion
            }
            
            print("Wersja z serwera: \(config.appVersion)")
            
            if config.appVersion != version {
                return true
            } else {
                return false
            }
        } catch {
            print("Błąd \(error)")
            return false
        }
    }
    
}
