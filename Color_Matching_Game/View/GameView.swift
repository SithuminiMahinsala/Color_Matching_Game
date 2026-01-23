//
//  GameView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-16.
//

import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    let gridSize: Int
    @State private var playerName: String = ""
    
    private let spacing: CGFloat = 8
    
    init(gridSize: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(gridSize: gridSize))
        self.gridSize = gridSize
    }
    
    var body: some View {
        VStack(spacing: 15) {
            //Header: Stats and Progress Bar
            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("SCORE")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        Text("\(viewModel.score)")
                            .font(.title2.bold())
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("FLIPS LEFT")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        Text("\(viewModel.movesRemaining)")
                            .font(.title2.bold())
                            .foregroundColor(viewModel.movesRemaining < 5 ? .red : .primary)
                    }
                }
                
                // Visual Progress Bar
                ProgressView(value: Double(viewModel.grid.filter { $0.isMatched }.count),
                             total: Double(viewModel.grid.count))
                    .tint(.green)
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer()

            //Game Grid Section
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: gridSize),
                      spacing: spacing) {
                ForEach(viewModel.grid.indices, id: \.self) { index in
                    CellView(cell: viewModel.grid[index])
                        .onTapGesture {
                            handleTap(index: index)
                        }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.05)))
            
            Spacer()
            
            //Status Overlays (Game Over / Win)
            VStack {
                if viewModel.isGameOver {
                    Text("GAME OVER")
                        .font(.system(.title, design: .rounded).bold())
                        .foregroundColor(.red)
                }
                
                // Victory View: Only shows when all items are matched
                if viewModel.grid.allSatisfy({ $0.isMatched }) && !viewModel.grid.isEmpty {
                    VStack(spacing: 12) {
                        Text("Well Done!")
                            .font(.system(.title, design: .rounded).bold())
                            .foregroundColor(.green)
                        
                        TextField("Enter name to save score", text: $playerName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            //Save score with mode calculation
                            viewModel.saveFinalScore(playerName: playerName, gridSize: gridSize)
                            
                            //Clear input
                            playerName = ""
                            
                            //RESET THE GAME IMMEDIATELY
                            viewModel.startNewGame(gridSize: gridSize)
                            
                            //Feedback
                            triggerNotificationHaptic(.success)
                        }) {
                            Text("Save & Rank Up")
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(playerName.isEmpty ? Color.gray : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(playerName.isEmpty)
                        .padding(.horizontal, 40)
                    }
                }
            }

            Spacer()
            
            //Action Buttons
            HStack(spacing: 15) {
                Button(action: {
                    viewModel.revealHint()
                    triggerImpactHaptic(.medium)
                }) {
                    Label("Hint", systemImage: "eye.fill")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isFlipping ? Color.gray : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 3)
                }
                .disabled(viewModel.isFlipping)
                
                Button(action: {
                    viewModel.startNewGame(gridSize: gridSize)
                    triggerImpactHaptic(.light)
                }) {
                    Label("Restart", systemImage: "arrow.clockwise")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 3)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    //Helper Functions and Haptics
    
    private func handleTap(index: Int) {
        if !viewModel.isGameOver {
            viewModel.selectCell(index)
            triggerImpactHaptic(.light)
        } else {
            triggerNotificationHaptic(.error)
        }
    }
    
    private func triggerNotificationHaptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    private func triggerImpactHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
