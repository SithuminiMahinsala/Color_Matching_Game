//
//  SettingsView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("soundEnabled") private var soundEnabled = true
    
    var body: some View {
        
        Form {
            Section(header: Text("Appearnce")) {
                Toggle("Dark mode", isOn: $isDarkMode)
            }
            
            Section(header: Text("Game Preferences")) {
                Toggle("Sound Effects", isOn: $soundEnabled)
            }
        }
        .navigationTitle("Settings")
    
    }
}
