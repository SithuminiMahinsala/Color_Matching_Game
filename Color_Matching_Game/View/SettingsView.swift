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
    @State private var showingTutorialAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $isDarkMode)
            }
            
            Section(header: Text("Game Preferences")) {
                Toggle("Sound Effects", isOn: $soundEnabled)
            }
            
            // --- New Debug/Testing Section ---
            Section(header: Text("Developer Tools")) {
                Button(action: {
                    showingTutorialAlert = true
                }) {
                    Label("Reset Tutorial Guide", systemImage: "arrow.counterclockwise")
                }
                
                Button(role: .destructive) {
                    showingResetAlert = true
                } label: {
                    Label("Reset All High Scores", systemImage: "trash")
                }
            }
            
            Section(header: Text("About Developer")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Sithumini Mahinsala") //
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
        // Alert for Tutorial Reset
        .alert("Reset Tutorial?", isPresented: $showingTutorialAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                UserDefaults.standard.set(false, forKey: "hasSeenTutorial") //
                triggerImpactHaptic(.medium)
            }
        } message: {
            Text("The tour guide will appear automatically next time you open the app.")
        }
        // Alert for Score Reset
        .alert("Clear All Data?", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete Everything", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will delete all leaderboards and history.")
        }
    }
    
    private func resetAllData() {
        UserDefaults.standard.removeObject(forKey: "high_scores") //
        triggerImpactHaptic(.heavy)
    }
    
    private func triggerImpactHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred() //
    }
}
