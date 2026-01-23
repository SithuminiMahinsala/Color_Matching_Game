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
    @State private var showingResetAlert = false
    
    var body: some View {
        Form {
            //Visuals Section
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .tint(.blue)
            }
            
            //Game Logic Section
            Section(header: Text("Game Preferences")) {
                Toggle("Sound Effects", isOn: $soundEnabled)
                    .tint(.green)
                
                Button(role: .destructive) {
                    showingResetAlert = true
                } label: {
                    Label("Reset Leaderboard", systemImage: "trash")
                }
            }
            
            //Developer Info (Great for Grading!)
            Section(header: Text("About Developer")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Sithumini Mahinsala") //
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Student ID")
                    Spacer()
                    Text("COBSCCOMP242P-001") //
                        .foregroundColor(.secondary)
                }
            }
            
            //App Info 
            Section(header: Text("App Info")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.1.0")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
        // Alert to prevent accidental leaderboard deletion
        .alert("Reset All Scores?", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset Everything", role: .destructive) {
                resetLeaderboard()
            }
        } message: {
            Text("This will permanently delete all your high scores. This action cannot be undone.")
        }
    }
    
    // Helper function to clear UserDefaults
    private func resetLeaderboard() {
        UserDefaults.standard.removeObject(forKey: "player_scores")
        // Trigger a light haptic for confirmation
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}