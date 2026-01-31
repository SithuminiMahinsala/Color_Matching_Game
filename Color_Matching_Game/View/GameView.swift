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
    let mode: String // Tracks current difficulty
    
    // username saved during the tutorial
    @AppStorage("username") private var username: String = "Player"
    
    private let spacing: CGFloat = 8
    
    init(gridSize: Int, mode: String) {
        self.gridSize = gridSize
        self.mode = mode
        
        _viewModel = StateObject(wrappedValue: GameViewModel(gridSize: gridSize, mode: mode))
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                //Stats and Progress Bar 
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
                        
                        // Mode Badge
                        Text(mode.uppercased())
                            .font(.caption2.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(5)
                        
                        Spacer()
                        
                        //Toggle between Time Left and Flips Left
                        VStack(alignment: .trailing) {
                            if mode == "Time Attack" {
                                Text("TIME LEFT")
                                    .font(.caption.bold())
                                    .foregroundColor(.secondary)
                                Text("\(viewModel.timeRemaining)s")
                                    .font(.title2.bold())
                                    .foregroundColor(viewModel.timeRemaining < 10 ? .red : .primary)
                            } else {
                                Text("FLIPS LEFT")
                                    .font(.caption.bold())
                                    .foregroundColor(.secondary)
                                Text("\(viewModel.movesRemaining)")
                                    .font(.title2.bold())
                                    .foregroundColor(viewModel.movesRemaining < 5 ? .red : .primary)
                            }
                        }
                    }
                    
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
                
                //Game Over / Win
                VStack {
                    if viewModel.isGameOver {
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded).bold())
                            .foregroundColor(.red)
                    }
                    
                    // Victory View with Profile Integration
                    if viewModel.grid.allSatisfy({ $0.isMatched }) && !viewModel.grid.isEmpty {
                        VStack(spacing: 12) {
                            Text("Victory!")
                                .font(.system(.title, design: .rounded).bold())
                                .foregroundColor(.green)
                            
                            Text("Your score has been saved to the leaderboard.")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Button("Play Again") {
                                viewModel.startNewGame(gridSize: gridSize)
                                triggerNotificationHaptic(.success)
                            }
                            .buttonStyle(.borderedProminent)
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
            //cleanup logic for the timer
            .onDisappear {
                viewModel.stopTimer()
            }
            
            //Confetti Overlay
            if viewModel.grid.allSatisfy({ $0.isMatched }) && !viewModel.grid.isEmpty {
                ConfettiView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
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
