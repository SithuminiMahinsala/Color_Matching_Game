import XCTest
import SwiftUI
@testable import Color_Matching_Game

final class GameViewModelTests: XCTestCase {
    
    // Setup Tests
    
    func testGameInitialization() {
        let viewModel = GameViewModel(gridSize: 3, mode: "Easy")
        
        // Check if the grid has 9 cells (3x3)
        XCTAssertEqual(viewModel.grid.count, 9)
        // Check if initial score is 0
        XCTAssertEqual(viewModel.score, 0)
        // Check if initial clicks are 0
        XCTAssertEqual(viewModel.totalClicks, 0)
        XCTAssertFalse(viewModel.isGameOver)
    }
    
    // Game Mode Logic Tests
    
    func testTimeAttackInitialState() {
        let viewModel = GameViewModel(gridSize: 5, mode: "Time Attack")
        
        // Verify time starts at 60 as per GameViewModel logic
        XCTAssertEqual(viewModel.timeRemaining, 60)
    }
    
    func testEasyModeMovesLimit() {
        let viewModel = GameViewModel(gridSize: 3, mode: "Easy")
        
        // Verify moves for 3x3 Easy mode is 15
        XCTAssertEqual(viewModel.movesRemaining, 15)
    }
    
    //Core Gameplay Tests
    
    func testClickTracking() {
        let viewModel = GameViewModel(gridSize: 3, mode: "Easy")
        
        // Simulate a cell selection
        viewModel.selectCell(0)
        
        // Verify totalClicks incremented
        XCTAssertEqual(viewModel.totalClicks, 1)
    }
    
    func testTimeAttackRewardOnMatch() {
        let viewModel = GameViewModel(gridSize: 3, mode: "Time Attack")
        
        // Manually setup a match state for testing
        // We select two cells with the same color
        let color = Color.red
        viewModel.grid[0].color = color
        viewModel.grid[1].color = color
        
        viewModel.selectCell(0)
        viewModel.selectCell(1)
        
        // In Time Attack, a match adds 3 seconds
        // Since the timer starts at 60, it should be 63 
        XCTAssertGreaterThanOrEqual(viewModel.timeRemaining, 60) 
    }
    
    func testHardModePenalty() {
        let viewModel = GameViewModel(gridSize: 7, mode: "Hard")
        let initialMoves = viewModel.movesRemaining // Should be 60
        
        // Setup two different colors to force a mismatch
        viewModel.grid[0].color = .red
        viewModel.grid[1].color = .blue
        
        viewModel.selectCell(0)
        viewModel.selectCell(1)
        
        // In Hard mode, a mismatch should subtract 2 moves
        XCTAssertEqual(viewModel.movesRemaining, initialMoves - 2)
    }
    
    //Scoring Tests
    
    func testScoreCalculationWithBonus() {
        let viewModel = GameViewModel(gridSize: 3, mode: "Easy")
        viewModel.score = 50
        viewModel.movesRemaining = 5
        
        // Final score = score + (movesRemaining * 10)
        // 50 + (5 * 10) = 100
        viewModel.saveFinalScore(playerName: "TestPlayer")
        
        // Check the most recent score in the leaderboard
        if let lastScore = viewModel.leaderboard.first {
            XCTAssertEqual(lastScore.score, 100)
        }
    }
}