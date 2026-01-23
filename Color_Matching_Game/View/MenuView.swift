//
//  MenuView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-16.
//

import SwiftUI

struct MenuView: View {
    // 1. Separate state variables for each mode's high score
    @State private var topScoreEasy: Int = 0
    @State private var topScoreMedium: Int = 0
    @State private var topScoreHard: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.15), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    VStack(spacing: 5) {
                        Text("Color Snap")
                            .font(.system(size: 45, weight: .black, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Select Difficulty")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // 2. Pass specific high scores to the buttons
                    VStack(spacing: 20) {
                        menuButton(title: "Easy", color: .green, gridSize: 3, topScore: topScoreEasy)
                        menuButton(title: "Medium", color: .yellow, gridSize: 5, topScore: topScoreMedium)
                        menuButton(title: "Hard", color: .red, gridSize: 7, topScore: topScoreHard)
                    }
                    
                    Spacer()
                    
                    Text("Match colors before your flips run out!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 20)
                }
                .padding()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: LeaderboardView()) {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.yellow)
                    }
                    
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .onAppear {
                loadAllHighScores()
            }
        }
    }
    
    // 3. Updated helper function to display the score inside the button
    func menuButton(title: String, color: Color, gridSize: Int, topScore: Int) -> some View {
        NavigationLink(destination: GameView(gridSize: gridSize)) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.title2.bold())
                    
                    if topScore > 0 {
                        Text("Best: \(topScore)")
                            .font(.caption.bold())
                            .opacity(0.9)
                    }
                }
                Spacer()
                Image(systemName: "play.circle.fill")
                    .font(.title)
            }
            .padding(.horizontal, 25)
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(20)
            .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
        }
    }
    
    // 4. Logic to filter and find the highest score for EACH mode
    func loadAllHighScores() {
        if let data = UserDefaults.standard.data(forKey: "high_scores"),
           let savedScores = try? JSONDecoder().decode([PlayerScore].self, from: data) {
            
            // Filter by mode name and find the maximum for each
            topScoreEasy = savedScores.filter { $0.mode == "Easy" }.map { $0.score }.max() ?? 0
            topScoreMedium = savedScores.filter { $0.mode == "Medium" }.map { $0.score }.max() ?? 0
            topScoreHard = savedScores.filter { $0.mode == "Hard" }.map { $0.score }.max() ?? 0
        }
    }
}
