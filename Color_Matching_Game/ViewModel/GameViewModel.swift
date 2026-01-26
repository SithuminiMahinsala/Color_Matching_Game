//
//  GridViewModel.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-16.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    // --- Published Properties (UI Auto-Refresh) ---
    @Published var grid: [GridCell] = []
    @Published var score: Int = 0
    @Published var isGameOver: Bool = false
    @Published var isFlipping: Bool = false
    @Published var movesRemaining: Int = 0
    @Published var leaderboard: [PlayerScore] = []
    @Published var timeRemaining: Int = 0 // Tracks seconds for Time Attack
    @Published var totalClicks: Int = 0 // Tracks every card tap for telemetry
    
    // --- Internal Properties ---
    private var gameTimer: AnyCancellable? // The actual clock engine
    var currentMode: String // Tracks current difficulty/mode
    private var selectedIndex: Int? = nil
    
    // Vibrant color palette for the game tiles
    private let normalColors: [Color] = [
        Color(red:240/255, green: 43/255, blue: 29/255),   // Red
        Color(red:34/255, green: 160/255, blue: 59/255),   // Green
        Color(red:26/255, green: 115/255, blue: 232/255),  // Blue
        Color(red:252/255, green: 194/255, blue: 0/255),   // Yellow
        Color(red:244/255, green: 121/255, blue: 32/255),  // Orange
        Color(red:111/255, green: 48/255, blue: 214/255),  // Purple
        Color(red:0/255, green: 191/255, blue: 213/255)    // Cyan
    ]
    
    // FIXED: Initialize mode first to avoid compiler errors
    init(gridSize: Int, mode: String) {
        self.currentMode = mode
        startNewGame(gridSize: gridSize)
    }
    
    // --- Core Game Logic ---
    
    func startNewGame(gridSize: Int) {
        score = 0
        totalClicks = 0 // Telemetry: Reset clicks
        isGameOver = false
        grid = []
        selectedIndex = nil
        
        // Stop any active timer before starting a new session
        stopTimer()
        
        // Telemetry: Start tracking the session duration
        TelemetryManager.shared.startTracking()
        
        // 1. Setup mode-specific limits
        if currentMode == "Time Attack" {
            timeRemaining = 60 // 60-second limit for Time Attack
        } else {
            switch gridSize {
            case 3: movesRemaining = 15
            case 5: movesRemaining = 35
            case 7: movesRemaining = 60
            default: movesRemaining = 20
            }
        }
        
        // 2. Prepare grid colors
        var pairs = (0..<(gridSize * gridSize) / 2).map { _ in
            normalColors.randomElement()!
        }
        if (gridSize * gridSize) % 2 == 1 {
            pairs.append(normalColors.randomElement()!)
        }
        let allColors = (pairs + pairs).shuffled().prefix(gridSize * gridSize)
        
        // 3. MEMORIZE PHASE: Cards start face-up in Hard/Memory Blitz
        let shouldPreview = (currentMode == "Hard" || currentMode == "Memory Blitz")
        grid = allColors.map { GridCell(color: $0, isSelected: shouldPreview) }
        
        if shouldPreview {
            isFlipping = true // Lock interaction
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.spring()) {
                    for i in self.grid.indices {
                        self.grid[i].isSelected = false
                    }
                    self.isFlipping = false // Unlock for player
                    self.startTimerIfRequired() // Start clock after preview
                }
            }
        } else {
            self.startTimerIfRequired()
        }
    }
    
    // --- Timer Engine ---
    
    private func startTimerIfRequired() {
        guard currentMode == "Time Attack" else { return }
        
        gameTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.isGameOver = true
                    self.stopTimer()
                }
            }
    }
    
    func stopTimer() {
        gameTimer?.cancel()
        gameTimer = nil
    }
    
    func revealHint() {
        guard !isFlipping else { return }
        isFlipping = true
        for i in grid.indices {
            if !grid[i].isMatched {
                grid[i].isSelected = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            for i in self.grid.indices {
                if !self.grid[i].isMatched {
                    self.grid[i].isSelected = false
                }
            }
            self.isFlipping = false
        }
    }
    
    func selectCell(_ index: Int) {
        // Validation: Block taps based on mode resources
        let isOutOfResources = (currentMode == "Time Attack") ? (timeRemaining <= 0) : (movesRemaining <= 0)
        guard !isFlipping, !grid[index].isMatched, !grid[index].isSelected, !isOutOfResources else { return }
        
        // Telemetry: Increment click counter
        totalClicks += 1
        grid[index].isSelected = true
        
        // Handle last remaining cell for odd-sized grids
        let unmatchedCount = grid.filter { !$0.isMatched }.count
        if unmatchedCount == 1 {
            grid[index].isMatched = true
            score += 5
            handleWin()
            return
        }
        
        if let firstIndex = selectedIndex {
            // Apply mode-specific penalties
            if currentMode != "Time Attack" {
                movesRemaining -= (currentMode == "Hard") ? 2 : 1
            }
            
            if grid[firstIndex].color == grid[index].color {
                // Match Found!
                grid[firstIndex].isMatched = true
                grid[index].isMatched = true
                score += 10
                selectedIndex = nil
                
                // Reward for Time Attack: Bonus time!
                if currentMode == "Time Attack" {
                    timeRemaining += 3
                }
                
                if grid.allSatisfy({ $0.isMatched }) {
                    handleWin()
                }
            } else {
                // No Match logic
                isFlipping = true
                
                let outOfResourcesAfterFlip = (currentMode == "Time Attack") ? (timeRemaining <= 0) : (movesRemaining <= 0)
                
                if outOfResourcesAfterFlip {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        self.isGameOver = true
                        self.stopTimer()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        self.grid[firstIndex].isSelected = false
                        self.grid[index].isSelected = false
                        self.selectedIndex = nil
                        self.isFlipping = false
                    }
                }
            }
        } else {
            selectedIndex = index
        }
    }

    private func handleWin() {
        stopTimer() // Kill clock on victory
        
        // Telemetry: Record session stats on win
        TelemetryManager.shared.endTracking(mode: currentMode, clicks: totalClicks)
        
        // 1. Increment persistent win counter for unlocking levels
        let currentWins = UserDefaults.standard.integer(forKey: "total_wins")
        UserDefaults.standard.set(currentWins + 1, forKey: "total_wins")
        
        // 2. AUTO-SAVE: Automatically save the score using the current profile
        let currentUsername = UserDefaults.standard.string(forKey: "username") ?? "Player"
        self.saveFinalScore(playerName: currentUsername)
        
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func saveFinalScore(playerName: String) {
        let modeName = self.currentMode

        // Calculate score based on mode resources
        let resourceBonus = (modeName == "Time Attack") ? (self.timeRemaining * 5) : (self.movesRemaining * 10)
        let finalScore = self.score + resourceBonus
        
        let newScore = PlayerScore(name: playerName, score: finalScore, mode: modeName, date: Date())
        
        if let data = UserDefaults.standard.data(forKey: "high_scores"),
           var savedScores = try? JSONDecoder().decode([PlayerScore].self, from: data) {
            savedScores.append(newScore)
            leaderboard = savedScores.sorted { $0.score > $1.score }
        } else {
            leaderboard = [newScore]
        }
        
        if let encoded = try? JSONEncoder().encode(leaderboard) {
            UserDefaults.standard.set(encoded, forKey: "high_scores")
        }
    }
}
