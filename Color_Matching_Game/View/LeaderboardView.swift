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
    @AppStorage("username") private var currentUsername: String = "Player"
    
    var filteredScores: [PlayerScore] {
        allScores.filter { $0.mode == selectedMode }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // --- NEW: Custom Mode Chip Bar ---
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    modeChip(title: "Easy", icon: "chart.bar")
                    modeChip(title: "Medium", icon: "chart.bar.fill")
                    modeChip(title: "Hard", icon: "bolt.fill")
                    modeChip(title: "Time Attack", icon: "clock.fill")
                    modeChip(title: "Memory Blitz", icon: "brain.headlight.fill")
                }
                .padding()
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
                        .listRowBackground(playerScore.name == currentUsername ? Color.blue.opacity(0.08) : Color(.secondarySystemGroupedBackground))
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Top Players")
        .onAppear(perform: loadScores)
    }
    
    // --- NEW: Chip UI Helper ---
    private func modeChip(title: String, icon: String) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedMode = title
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.subheadline.bold())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(selectedMode == title ? Color.blue : Color.white)
            .foregroundColor(selectedMode == title ? .white : .primary)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
    
    private func circleColor(for index: Int) -> Color {
        switch index {
        case 0: return .yellow
        case 1: return .gray.opacity(0.8)
        case 2: return .orange.opacity(0.9)
        default: return .blue.opacity(0.4)
        }
    }
    
    func loadScores() {
        if let data = UserDefaults.standard.data(forKey: "high_scores"),
           let decoded = try? JSONDecoder().decode([PlayerScore].self, from: data) {
            self.allScores = decoded.sorted {
                if $0.score == $1.score { return $0.date > $1.date }
                return $0.score > $1.score
            }
        }
    }
}
