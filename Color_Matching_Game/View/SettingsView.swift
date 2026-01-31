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
    @AppStorage("username") private var username: String = "Player" // Persistent profile name
    
    @State private var showingResetAlert = false
    @State private var showingTutorialAlert = false
    
    var body: some View {
        Form {
            //Player Profile Section
            Section(header: Text("Player Profile")) {
                HStack {
                    Text("Username")
                    Spacer()
                    TextField("Name", text: $username)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.blue)
                }
            }
            
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $isDarkMode)
            }
            
            Section(header: Text("Game Preferences")) {
                Toggle("Sound Effects", isOn: $soundEnabled)
            }
            
            //Developer Tools
            Section(header: Text("Developer Tools")) {
                Button(action: {
                    showingTutorialAlert = true
                }) {
                    Label("Reset Tutorial Guide", systemImage: "arrow.counterclockwise")
                }
                
                Button(role: .destructive) {
                    showingResetAlert = true
                } label: {
                    Label("Reset All Data & Progress", systemImage: "trash")
                }
            }
            
            Section(header: Text("Legal")) {
                NavigationLink(destination: PrivacyView()) {
                    Label("Privacy Policy", systemImage: "shield.lefthalf.filled")
                }
                
                NavigationLink(destination: TermsOfServiceView()) {
                    Label("Terms of Service", systemImage: "doc.text")
                }
            }
            
            Section(header: Text("Developer Diagnostics")) {
                NavigationLink(destination: TelemetryLogView()) {
                    Label("View Session Telemetry", systemImage: "chart.xyaxis.line")
                }
            }
            
            Section(header: Text("About Developer")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Sithumini Mahinsala")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
        
        // Alerts for Reset Actions
        .alert("Reset Tutorial?", isPresented: $showingTutorialAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                UserDefaults.standard.set(false, forKey: "hasSeenTutorial")
                triggerImpactHaptic(.medium)
            }
        } message: {
            Text("The tour guide will appear automatically next time you open the app.")
        }
        
        .alert("Clear All Data?", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete Everything", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will delete all leaderboards, win counts, and level unlock progress.")
        }
    }
    
    // Logic to clear persistent stats
    private func resetAllData() {
        UserDefaults.standard.removeObject(forKey: "high_scores")
        UserDefaults.standard.removeObject(forKey: "total_wins")
        triggerImpactHaptic(.heavy)
    }
    
    private func triggerImpactHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
