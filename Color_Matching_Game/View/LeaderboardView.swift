//
//  LeaderboardView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-23.
//

import SwiftUI

struct LeaderboardView: View {
    @State private var allScores: [PlayerScore] = []
    @State private var selectedMode = "Easy" // Default filter
    
    // Computed property to filter scores based on selection
    var filteredScores: [PlayerScore] {
        allScores.filter { $0.mode == selectedMode }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            //Mode Selector 
            Picker("Select Mode", selection: $selectedMode) {
                Text("Easy").tag("Easy")
                Text("Medium").tag("Medium")
                Text("Hard").tag("Hard")
            }
            .pickerStyle(.segmented)
            .padding()
            .background(Color(.systemGroupedBackground))
            
            //Leaderboard List
            List {
                if filteredScores.isEmpty {
                    Section {
                        Text("No scores for \(selectedMode) mode yet!")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                } else {
                    ForEach(Array(filteredScores.enumerated()), id: \.element.id) { index, playerScore in
                        HStack(spacing: 15) {
                            // Rank Number
                            Text("\(index + 1)")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                                .background(circleColor(for: index))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(playerScore.name)
                                    .font(.headline)
                                Text(playerScore.date, style: .date) // Displays date of win
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("\(playerScore.score) pts")
                                .font(.system(.body, design: .monospaced).bold())
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Top Players")
        .onAppear(perform: loadScores)
    }
    
    // Helper to color the top 3 spots
    private func circleColor(for index: Int) -> Color {
        switch index {
        case 0: return .yellow // Gold
        case 1: return .gray.opacity(0.7) // Silver
        case 2: return .orange.opacity(0.8) // Bronze
        default: return .blue.opacity(0.3)
        }
    }
    
    func loadScores() {
        if let data = UserDefaults.standard.data(forKey: "high_scores"),
           let decoded = try? JSONDecoder().decode([PlayerScore].self, from: data) {
            self.allScores = decoded
        }
    }
}
