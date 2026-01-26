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
    
    var currentMode: String
    
    // Tracks the index of the first card clicked in a pair attempt
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
    
    init(gridSize: Int, mode: String) {
            self.currentMode = mode
            startNewGame(gridSize: gridSize)
        }
    
    // --- Core Game Logic ---
    
    func startNewGame(gridSize: Int) {
        score = 0
        isGameOver = false
        grid = []
        selectedIndex = nil
        
        // Define flip limits based on difficulty
        switch gridSize {
        case 3: movesRemaining = 15
        case 5: movesRemaining = 35
        case 7: movesRemaining = 60
        default: movesRemaining = 20
        }
        
        // Prepare pairs of colors
        var pairs = (0..<(gridSize * gridSize) / 2).map { _ in
            normalColors.randomElement()!
        }
        
        // Handle odd-numbered grids (like 3x3)
        if (gridSize * gridSize) % 2 == 1 {
            pairs.append(normalColors.randomElement()!)
        }
        
        // Shuffle and assign to the grid
        let allColors = (pairs + pairs).shuffled().prefix(gridSize * gridSize)
        grid = allColors.map { GridCell(color: $0) }
    }
    
    func revealHint() {
        isFlipping = true
        for i in grid.indices {
            if !grid[i].isMatched {
                grid[i].isSelected = true
            }
        }
        
        // Hide cards again after 1.5 seconds
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
        // Validation: Block taps if flipping, matched, already selected, or out of moves
        guard !isFlipping, !grid[index].isMatched, !grid[index].isSelected, movesRemaining > 0 else { return }
        
        grid[index].isSelected = true
        
        // Special case: Single remaining unmatched cell (odd grids)
        let unmatchedCount = grid.filter { !$0.isMatched }.count
        if unmatchedCount == 1 {
            grid[index].isMatched = true
            score += 5
            handleWin() // Trigger progression logic
            return
        }
        
        if let firstIndex = selectedIndex {
            // This is the second card being flipped
            movesRemaining -= 1
            
            if grid[firstIndex].color == grid[index].color {
                // Match Found!
                grid[firstIndex].isMatched = true
                grid[index].isMatched = true
                score += 10
                selectedIndex = nil
                
                // Check if the whole board is cleared
                if grid.allSatisfy({ $0.isMatched }) {
                    handleWin()
                }
            } else {
                // No Match: Show cards briefly then flip back
                isFlipping = true
                
                if movesRemaining <= 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        self.isGameOver = true
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
            // This is the first card being flipped
            selectedIndex = index
        }
    }

    // --- Progression & Level Locking Logic ---
    
    /// Called when the player successfully clears the grid.
    /// Increments the persistent win counter for level unlocking.
    private func handleWin() {
        // Get existing wins from disk
        let currentWins = UserDefaults.standard.integer(forKey: "total_wins")
        
        // Save updated win count
        UserDefaults.standard.set(currentWins + 1, forKey: "total_wins")
        
        // Provide physical feedback for the win
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // --- Data Persistence (Leaderboard) ---
    
    func saveFinalScore(playerName: String, gridSize: Int) {
        let modeName: String
        switch gridSize {
        case 3: modeName = "Easy"
        case 5: modeName = "Medium"
        case 7: modeName = "Hard"
        default: modeName = "Unknown"
        }

        // Professional Scoring Logic: Accuracy (Matches) + Efficiency (Flips Remaining)
        let finalScore = self.score + (self.movesRemaining * 10)
        let newScore = PlayerScore(name: playerName, score: finalScore, mode: modeName, date: Date())
        
        if let data = UserDefaults.standard.data(forKey: "high_scores"),
           var savedScores = try? JSONDecoder().decode([PlayerScore].self, from: data) {
            savedScores.append(newScore)
            // Sort leaderboard by Score (Desc) and then Date
            leaderboard = savedScores.sorted {
                if $0.score == $1.score { return $0.date > $1.date }
                return $0.score > $1.score
            }
        } else {
            leaderboard = [newScore]
        }
        
        // Save encoded JSON back to UserDefaults
        if let encoded = try? JSONEncoder().encode(leaderboard) {
            UserDefaults.standard.set(encoded, forKey: "high_scores")
        }
    }
}
