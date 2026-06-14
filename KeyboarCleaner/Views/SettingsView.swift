//
//  SettingsView.swift
//  KeyboarCleaner
//
//  Created by Mateusz Rybczyński on 31/05/2026.
//

import SwiftUI

enum SettingsTab: String, CaseIterable, Identifiable {
    case general = "general"
    case updates = "updates"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .general: return "gearshape"
        case .updates: return "arrow.clockwise.circle"
        }
    }
}

struct SettingsView: View {

    @State private var selectedTab: SettingsTab? = .general
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("settings")
                
                List {
                    ForEach(SettingsTab.allCases) { tab in
                        Button(action: {
                            selectedTab = tab
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: tab.iconName)
                                    .font(.system(size: 14))
                                    .frame(width: 18, alignment: .center)
                                    .foregroundColor(selectedTab == tab ? .blue : .primary.opacity(0.8))
                                
                                Text(LocalizedStringKey(tab.rawValue))
                                    .font(.system(size: 13))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(SidebarButtonStyle(isSelected: selectedTab == tab))
                    }
                }
                .listStyle(SidebarListStyle())
                
                Spacer()
                
                VStack(spacing: 0) {
                    Divider()
                    HStack(spacing: 12) {
                        // Logo aplikacji oparte na SF Symbols
                        Image(nsImage: NSApplication.shared.applicationIconImage)
                            .resizable()
                            .font(.system(size: 18))
                            .frame(width: 32, height: 32)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("WipeKeys")
                                .font(.system(size: 13, weight: .bold))
                            Text("Version \(version)")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(BlurView(material: .sidebar, blendingMode: .withinWindow))
                }
            }
            .frame(minWidth: 220, idealWidth: 220, maxWidth: 220)
            
            DynamicContentView(selectedTab: selectedTab!)
            
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    
    struct SidebarButtonStyle: ButtonStyle {
        let isSelected: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isSelected ? Color.blue.opacity(0.12) : (configuration.isPressed ? Color.primary.opacity(0.05) : Color.clear))
                )
                .foregroundColor(isSelected ? .blue : .primary)
                .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
        }
    }
    
    struct BlurView: NSViewRepresentable {
        let material: NSVisualEffectView.Material
        let blendingMode: NSVisualEffectView.BlendingMode
        
        func makeNSView(context: Context) -> NSVisualEffectView {
            let visualEffectView = NSVisualEffectView()
            visualEffectView.material = material
            visualEffectView.blendingMode = blendingMode
            visualEffectView.state = .active
            return visualEffectView
        }
        
        func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
            nsView.material = material
            nsView.blendingMode = blendingMode
        }
    }
    
    
    
    
}

#Preview {
    SettingsView()
}
