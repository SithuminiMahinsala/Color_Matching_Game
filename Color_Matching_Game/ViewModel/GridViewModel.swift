//
//  GridViewModel.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-16.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    //@published triggers a UI refresh whenever these values change
    @Published var grid: [GridCell] = []
    @Published var score: Int = 0
    @Published var isGameOver: Bool = false
    @Published var isFlipping: Bool = false
    @Published var movesRemaining: Int = 0
    @Published var leaderboard: [PlayerScore] = []
    
    // Tracks the first square the user clicked
    private var selectedIndex: Int? = nil
    
    //List all vibrant colors for the game
    private let normalColors: [Color] = [
        Color(red:240/255, green: 43/255, blue: 29/255),  //vibrant red
        Color(red:34/255, green: 160/255, blue: 59/255),  //vibrant green
        Color(red:26/255, green: 115/255, blue: 232/255), //vibrant blue
        Color(red:252/255, green: 194/255, blue: 0/255),  //vibrant Yellow
        Color(red:244/255, green: 121/255, blue: 32/255), //vibrant orange
        Color(red:111/255, green: 48/255, blue: 214/255), //vibrant purple
        Color(red:0/255, green: 191/255, blue: 213/255)  //vibrant cyan
    ]
    
    init(gridSize: Int) {
        startNewGame(gridSize: gridSize)
    }
    
    //Setup a new game with shuffled pairs
    func startNewGame(gridSize: Int) {
        score = 0
        isGameOver = false
        grid = []
        selectedIndex = nil
        
        //set move limits on difficulty
        switch gridSize {
        case 3: movesRemaining = 15
        case 5: movesRemaining = 35
        case 7: movesRemaining = 60
        default: movesRemaining = 20
        }
        
        //1.Generate random pairs of colors
        var pairs = (0..<(gridSize * gridSize) / 2).map { _ in
            normalColors.randomElement()!
        }
        
        //2.Handled odd sized grids(like 3*3)
        if(gridSize * gridSize) % 2 == 1 {
            pairs.append(normalColors.randomElement()!)
        }
        
        //3.Duplicate & shuffle the colors
        let allColors = (pairs + pairs).shuffled().prefix(gridSize * gridSize)
        grid = allColors.map { GridCell(color: $0) }
        
    }
    
    //reveal hint
    func revealHint(){
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
    
    //Handles what happens user taps the cell
    func selectCell(_ index: Int) {
        guard !isFlipping, !grid[index].isMatched, !grid[index].isSelected, movesRemaining > 0 else { return }
        
        grid[index].isSelected = true
        
        //check if this is the last remaining unmatched cell
        let unmatchedCount = grid.filter { !$0.isMatched }.count
        if unmatchedCount == 1 {
            grid[index].isMatched = true
            score += 5
            return
        }
        
        if let firstIndex = selectedIndex {
            
            
            movesRemaining -= 1
            if grid[firstIndex].color == grid[index].color {
                grid[firstIndex].isMatched = true
                grid[index].isMatched = true
                score += 10
                selectedIndex = nil
            }else {
                isFlipping = true
                
                //check if that was last move
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
            selectedIndex = index
        }
    }
    
    // Save players and scores
    func saveFinalScore(playerName: String, gridSize: Int) {
        // 1. Determine mode name based on grid size
        let modeName: String
        switch gridSize {
        case 3: modeName = "Easy"
        case 5: modeName = "Medium"
        case 7: modeName = "Hard"
        default: modeName = "Unknown"
        }

        // 2. Calculate final score: Match Points + (Remaining Flips * 10)
        let finalScore = self.score + (self.movesRemaining * 10)
        
        let newScore = PlayerScore(name: playerName, score: finalScore, mode: modeName, date: Date())
        
        // 3. Update the leaderboard
        if let data = UserDefaults.standard.data(forKey: "high_scores"),
           var savedScores = try? JSONDecoder().decode([PlayerScore].self, from: data) {
            savedScores.append(newScore)
            // Sort by score descending, then by date
            leaderboard = savedScores.sorted {
                if $0.score == $1.score { return $0.date > $1.date }
                return $0.score > $1.score
            }
        } else {
            leaderboard = [newScore]
        }
        
        // 4. Save back to disk
        if let encoded = try? JSONEncoder().encode(leaderboard) {
            UserDefaults.standard.set(encoded, forKey: "high_scores")
        }
    }
}
