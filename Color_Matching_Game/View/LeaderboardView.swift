//
//  LeaderboardView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-23.
//

import SwiftUI

struct LeaderboardView: View {
    @State private var allScores: [PlayerScore] = []
    @State private var selectedMode = "Easy"
    
    // Fetches your saved name to highlight your scores
    @AppStorage("username") private var currentUsername: String = "Player"
    
    var filteredScores: [PlayerScore] {
        allScores.filter { $0.mode == selectedMode }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // --- Expanded Mode Selector ---
            // Added Time Attack and Memory Blitz to match your new game modes
            ScrollView(.horizontal, showsIndicators: false) {
                Picker("Select Mode", selection: $selectedMode) {
                    Text("Easy").tag("Easy")
                    Text("Medium").tag("Medium")
                    Text("Hard").tag("Hard")
                    Text("Time Attack").tag("Time Attack")
                    Text("Memory Blitz").tag("Memory Blitz")
                }
                .pickerStyle(.segmented)
                .padding()
                .frame(minWidth: 500) // Ensures all tabs are visible and tappable
            }
            .background(Color(.systemGroupedBackground))
            
            // --- Leaderboard List ---
            List {
                if filteredScores.isEmpty {
                    Section {
                        Text("No scores for \(selectedMode) yet!")
                            .foregroundColor(.secondary)
                            .italic()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                } else {
                    ForEach(Array(filteredScores.enumerated()), id: \.element.id) { index, playerScore in
                        HStack(spacing: 15) {
                            // Rank Number with Top 3 Styling
                            Text("\(index + 1)")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(circleColor(for: index))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(playerScore.name)
                                        .font(.headline)
                                    
                                    // NEW: Indicator for the current player
                                    if playerScore.name == currentUsername {
                                        Text("YOU")
                                            .font(.system(size: 10, weight: .black))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(4)
                                    }
                                }
                                
                                Text(playerScore.date, style: .date)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("\(playerScore.score) pts")
                                .font(.system(.body, design: .monospaced).bold())
                                .foregroundColor(playerScore.name == currentUsername ? .blue : .primary)
                        }
                        .padding(.vertical, 5)
                        // HIGHLIGHT: Makes your own score rows stand out
                        .listRowBackground(playerScore.name == currentUsername ? Color.blue.opacity(0.08) : Color(.secondarySystemGroupedBackground))
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Top Players")
        .onAppear(perform: loadScores)
    }
    
    private func circleColor(for index: Int) -> Color {
        switch index {
        case 0: return .yellow // Gold
        case 1: return .gray.opacity(0.8) // Silver
        case 2: return .orange.opacity(0.9) // Bronze
        default: return .blue.opacity(0.4)
        }
    }
    
    func loadScores() {
        if let data = UserDefaults.standard.data(forKey: "high_scores"),
           let decoded = try? JSONDecoder().decode([PlayerScore].self, from: data) {
            // Sort by score and then by date to handle ties professionally
            self.allScores = decoded.sorted {
                if $0.score == $1.score { return $0.date > $1.date }
                return $0.score > $1.score
            }
        }
    }
}
