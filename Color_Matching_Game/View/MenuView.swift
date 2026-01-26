//
//  MenuView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-16.
//

import SwiftUI

struct MenuView: View {
    // High scores for each mode
    @State private var topScoreEasy: Int = 0
    @State private var topScoreMedium: Int = 0
    @State private var topScoreHard: Int = 0
    
    // Tracks total wins to handle level unlocking
    @State private var totalWins: Int = 0
    
    // Onboarding trigger
    @State private var showingTutorial = !UserDefaults.standard.bool(forKey: "hasSeenTutorial")
    
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
                    
                    // --- Progression Progress Section ---
                    if totalWins < 10 {
                        VStack(spacing: 8) {
                            Text("Total Wins: \(totalWins)")
                                .font(.subheadline.bold())
                                .foregroundColor(.blue)
                            
                            // Visual hint for the next unlock
                            let nextGoal = totalWins < 3 ? 3 : 10
                            let modeName = totalWins < 3 ? "Medium" : "Hard"
                            
                            Text("\(nextGoal - totalWins) more wins to unlock \(modeName)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Capsule().fill(Color.blue.opacity(0.1)))
                    }

                    Spacer()
                    
                    // Difficulty Buttons with Locking Logic
                    VStack(spacing: 20) {
                        // Easy: Always Unlocked
                        menuButton(title: "Easy", color: .green, gridSize: 3, topScore: topScoreEasy, isLocked: false)
                        
                        // Medium: Unlocks after 3 wins
                        menuButton(title: "Medium", color: .yellow, gridSize: 5, topScore: topScoreMedium, isLocked: totalWins < 3)
                        
                        // Hard: Unlocks after 10 wins
                        menuButton(title: "Hard", color: .red, gridSize: 7, topScore: topScoreHard, isLocked: totalWins < 10)
                    }
                    
                    Spacer()
                    
                    Text("Match colors before your flips run out!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 20)
                }
                .padding()
            }
            .fullScreenCover(isPresented: $showingTutorial) {
                TutorialView()
                    .onDisappear {
                        UserDefaults.standard.set(true, forKey: "hasSeenTutorial")
                    }
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
                loadAllStats()
            }
        }
    }
    
    // Helper function for difficulty buttons with locking UI
    func menuButton(title: String, color: Color, gridSize: Int, topScore: Int, isLocked: Bool) -> some View {
        NavigationLink(destination: GameView(gridSize: gridSize)) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.title2.bold())
                    
                    if isLocked {
                        Text("Locked")
                            .font(.caption.bold())
                            .opacity(0.8)
                    } else if topScore > 0 {
                        Text("Best: \(topScore)")
                            .font(.caption.bold())
                            .opacity(0.9)
                    }
                }
                Spacer()
                // Show a lock icon if the mode is unavailable
                Image(systemName: isLocked ? "lock.fill" : "play.circle.fill")
                    .font(.title)
            }
            .padding(.horizontal, 25)
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            // Visual feedback for locked state: Grey and transparent
            .background(isLocked ? Color.gray : color)
            .foregroundColor(.white)
            .cornerRadius(20)
            .shadow(color: isLocked ? Color.clear : color.opacity(0.4), radius: 8, x: 0, y: 4)
            .opacity(isLocked ? 0.6 : 1.0)
            .padding(.horizontal)
        }
        .disabled(isLocked) // Prevent navigation if locked
    }
    
    // Loads high scores and win progression from UserDefaults
    func loadAllStats() {
        // Refresh total wins for locking logic
        totalWins = UserDefaults.standard.integer(forKey: "total_wins")
        
        // Refresh high scores for each mode
        if let data = UserDefaults.standard.data(forKey: "high_scores"),
           let savedScores = try? JSONDecoder().decode([PlayerScore].self, from: data) {
            
            topScoreEasy = savedScores.filter { $0.mode == "Easy" }.map { $0.score }.max() ?? 0
            topScoreMedium = savedScores.filter { $0.mode == "Medium" }.map { $0.score }.max() ?? 0
            topScoreHard = savedScores.filter { $0.mode == "Hard" }.map { $0.score }.max() ?? 0
        }
    }
}
