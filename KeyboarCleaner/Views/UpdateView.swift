//
//  UpdateView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 6/5/2026.
//

import SwiftUI

struct UpdateView: View {
    @StateObject private var updateManager = UpdateManager()
    
    @Environment(\.openURL) private var openURL
    
    @State var toUpdate: Bool = false
    @State var updateChecked: Bool = false
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading, spacing: 10) {
                Text("updates")
                    .font(.system(size: 14, weight: .bold))
                
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.rectangle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.green)
                        .frame(width: 34, height: 34)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("updTitile")
                            .font(.system(size: 13, weight: .medium))
                        Text("updDesc")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if !updateChecked {
                        Button("updBtn") {
                            Task {
                                let success = await updateManager.checkForUpdates()
                                print("Sukces: \(success)")
                                toUpdate = success
                                updateChecked = true
                            }
                        }
                    }
                    
                }
                .padding(.all, 14)
                .background(Color.primary.opacity(0.03))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary.opacity(0.06), lineWidth: 1)
                )
            }
            
            if updateChecked {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(nsImage: NSApplication.shared.applicationIconImage)
                            .resizable()
                            .font(.system(size: 28))
                            .frame(width:
                                   52, height: 52)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        
                        VStack(alignment: .leading) {
                            Text("KeyClean")
                                .font(.title)
                            Text("appMotto")
                        }
                        .padding(.leading,3)
                        
                        Spacer()
                        
                        if toUpdate {
                            Button("Aktualizuj") {
                                Task {
                                    if let url = URL(string: "https://apps.apple.com/pl/app/twoja-aplikacja/id6757436231") {
                                        openURL(url)
                                    }
                                }
                            }
                        } else {
                            Text("Aplikacja jest najnowsza")
                        }
                        
                    }
                }
                .padding(.all, 14)
                .background(Color.primary.opacity(0.03))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary.opacity(0.06), lineWidth: 1)
                )
                
            }
            
            
            
        }
    }
}

#Preview {
    UpdateView()
}
