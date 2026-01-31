//
//  TelemetrLogView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-26.
//

import SwiftUI

struct TelemetryLogView: View {
    @StateObject private var telemetry = TelemetryManager.shared
    
    var body: some View {
        List {
            if telemetry.sessions.isEmpty {
                Text("No telemetry data recorded yet.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(telemetry.sessions) { session in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(session.mode)
                                .font(.headline)
                            Spacer()
                            Text("\(session.durationSeconds) seconds")
                                .font(.caption.bold())
                                .foregroundColor(.blue)
                        }
                        HStack {
                            Label("\(session.clicks) Clicks", systemImage: "hand.tap")
                            Spacer()
                            Text(session.date, style: .time)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                
                Button("Clear Logs", role: .destructive) {
                    telemetry.clearLogs()
                }
            }
        }
        .navigationTitle("Game Telemetry")
    }
}
