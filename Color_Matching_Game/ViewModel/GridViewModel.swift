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
    
    //Handles what happens user taps the cell
    func selectCell(_ index: Int) {
        guard !grid[index].isMatched, !grid[index].isSelected else { return }
        
        grid[index].isSelected = true
        
        if let firstIndex = selectedIndex {
            if grid[firstIndex].color == grid[index].color {
                grid[firstIndex].isMatched = true
                grid[index].isMatched = true
                score += 10
            }else {
                isGameOver = true
            }
            
            selectedIndex = nil
        } else {
            selectedIndex = index
        }
    }
}
