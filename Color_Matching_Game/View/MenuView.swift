//
//  MenuView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-16.
//

import SwiftUI

struct MenuView: View {
    // --- Persistence & State ---
    @AppStorage("username") private var username: String = "Player" // Persistent username
    @State private var topScoreEasy: Int = 0
    @State private var topScoreMedium: Int = 0
    @State private var topScoreHard: Int = 0
    @State private var totalWins: Int = UserDefaults.standard.integer(forKey: "total_wins")
    @State private var showingTutorial = !UserDefaults.standard.bool(forKey: "hasSeenTutorial")
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), .white]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        
                        // --- Personalized Header ---
                        VStack(spacing: 5) {
                            Text("Hello, \(username)!")
                                .font(.subheadline.bold())
                                .foregroundColor(.blue)
                            
                            Text("Color Snap")
                                .font(.system(size: 45, weight: .black, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text("MASTER YOUR MEMORY")
                                .font(.caption.bold())
                                .tracking(2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 30)
                        
                        // --- Progress Tracker ---
                        VStack(spacing: 12) {
                            HStack {
                                Label("\(totalWins) Wins", systemImage: "trophy.fill")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                Spacer()
                                Text(rankTitle)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                            if totalWins < 20 {
                                let goal = nextGoalInfo.goal
                                let next = nextGoalInfo.name
                                ProgressView(value: Double(totalWins), total: Double(goal))
                                    .tint(.blue)
                                
                                Text("\(goal - totalWins) more wins to unlock \(next)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white).shadow(color: .black.opacity(0.05), radius: 10))
                        .padding(.horizontal)

                        // --- Classic Progression Section ---
                        VStack(alignment: .leading, spacing: 15) {
                            sectionHeader(title: "Classic Levels", icon: "chart.bar.fill")
                            
                            menuButton(title: "Easy", color: .green, gridSize: 3, topScore: topScoreEasy, isLocked: false)
                            menuButton(title: "Medium", color: .orange, gridSize: 5, topScore: topScoreMedium, isLocked: totalWins < 3)
                            menuButton(title: "Hard", color: .red, gridSize: 7, topScore: topScoreHard, isLocked: totalWins < 10)
                        }
                        
                        // --- Special Challenges Section ---
                        VStack(alignment: .leading, spacing: 15) {
                            sectionHeader(title: "Special Challenges", icon: "bolt.fill")
                            
                            menuButton(title: "Time Attack", color: .purple, gridSize: 5, topScore: 0, isLocked: totalWins < 15)
                            menuButton(title: "Memory Blitz", color: .indigo, gridSize: 6, topScore: 0, isLocked: totalWins < 20)
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .fullScreenCover(isPresented: $showingTutorial) {
                TutorialView()
                    .onDisappear {
                        UserDefaults.standard.set(true, forKey: "hasSeenTutorial")
                    }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: LeaderboardView()) { Image(systemName: "crown.fill").foregroundColor(.yellow) }
                    NavigationLink(destination: SettingsView()) { Image(systemName: "gearshape.fill").foregroundColor(.gray) }
                }
            }
            .onAppear { loadAllStats() }
        }
    }

    // --- Helper UI Components ---
    
    func sectionHeader(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(title.uppercased())
                .font(.system(.caption, design: .rounded).bold())
        }
        .padding(.horizontal, 25)
    }

    func menuButton(title: String, color: Color, gridSize: Int, topScore: Int, isLocked: Bool) -> some View {
        // Pass both gridSize and title (as mode) to GameView
        NavigationLink(destination: GameView(gridSize: gridSize, mode: title)) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.headline)
                    if !isLocked && topScore > 0 {
                        Text("Best Score: \(topScore)").font(.caption2).opacity(0.8)
                    }
                }
                Spacer()
                Image(systemName: isLocked ? "lock.fill" : "chevron.right")
            }
            .padding(.horizontal, 20)
            .frame(height: 64)
            .background(isLocked ? Color.gray.opacity(0.2) : color)
            .foregroundColor(isLocked ? .gray : .white)
            .cornerRadius(16)
            .padding(.horizontal)
        }
        .disabled(isLocked)
    }

    // --- Logic ---
    
    var nextGoalInfo: (goal: Int, name: String) {
        if totalWins < 3 { return (3, "Medium") }
        if totalWins < 10 { return (10, "Hard") }
        if totalWins < 15 { return (15, "Time Attack") }
        return (20, "Memory Blitz")
    }
    
    var rankTitle: String {
        if totalWins < 3 { return "Beginner" }
        if totalWins < 10 { return "Amateur" }
        if totalWins < 15 { return "Expert" }
        return "Grandmaster"
    }

    func loadAllStats() {
        totalWins = UserDefaults.standard.integer(forKey: "total_wins")
        if let data = UserDefaults.standard.data(forKey: "high_scores"),
           let savedScores = try? JSONDecoder().decode([PlayerScore].self, from: data) {
            
            topScoreEasy = savedScores.filter { $0.mode == "Easy" }.map { $0.score }.max() ?? 0
            topScoreMedium = savedScores.filter { $0.mode == "Medium" }.map { $0.score }.max() ?? 0
            topScoreHard = savedScores.filter { $0.mode == "Hard" }.map { $0.score }.max() ?? 0
        }
    }
}
