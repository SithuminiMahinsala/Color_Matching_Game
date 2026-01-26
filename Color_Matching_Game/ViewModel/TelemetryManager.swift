//
//  TelemetryManager.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-26.
//
import Foundation

// Structure to hold individual game session data
struct GameSession: Codable, Identifiable {
    var id = UUID()
    let mode: String
    let clicks: Int
    let durationSeconds: Int
    let date: Date
}

class TelemetryManager: ObservableObject {
    static let shared = TelemetryManager() // Singleton for app-wide access
    
    @Published var sessions: [GameSession] = []
    private var startTime: Date?
    
    init() {
        self.sessions = fetchSessions()
    }
    
    // Marks the beginning of a game session
    func startTracking() {
        startTime = Date()
    }
    
    // Calculates duration and saves the session
    func endTracking(mode: String, clicks: Int) {
        guard let start = startTime else { return }
        let duration = Int(Date().timeIntervalSince(start))
        
        let newSession = GameSession(mode: mode, clicks: clicks, durationSeconds: duration, date: Date())
        saveSession(newSession)
        
        // Console output for your lab demonstration
        print("📊 Telemetry Saved: \(mode) | \(clicks) Clicks | \(duration)s")
    }
    
    private func saveSession(_ session: GameSession) {
        var logs = fetchSessions()
        logs.insert(session, at: 0) // Keep newest at the top
        
        if let encoded = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(encoded, forKey: "telemetry_logs")
            // Update the published property to refresh the UI
            DispatchQueue.main.async {
                self.sessions = logs
            }
        }
    }
    
    func fetchSessions() -> [GameSession] {
        if let data = UserDefaults.standard.data(forKey: "telemetry_logs"),
           let decoded = try? JSONDecoder().decode([GameSession].self, from: data) {
            return decoded
        }
        return []
    }
    
    func clearLogs() {
        UserDefaults.standard.removeObject(forKey: "telemetry_logs")
        self.sessions = []
    }
}
