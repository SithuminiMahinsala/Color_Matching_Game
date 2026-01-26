//
//  TutorialView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-23.
//
import SwiftUI

struct TutorialStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    
    let steps = [
        TutorialStep(title: "Match Colors", description: "Tap tiles to find matching colors. Clear the board to win!", icon: "paintpalette.fill", color: .blue),
        TutorialStep(title: "Save Flips", description: "Every flip left at the end adds 10 bonus points to your score!", icon: "star.circle.fill", color: .orange),
        TutorialStep(title: "Global Ranking", description: "Enter your name after winning to climb the leaderboards.", icon: "trophy.fill", color: .yellow)
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            VStack {
                TabView {
                    ForEach(steps) { step in
                        VStack(spacing: 20) {
                            Image(systemName: step.icon)
                                .font(.system(size: 80))
                                .foregroundColor(step.color)
                            
                            Text(step.title)
                                .font(.largeTitle.bold())
                            
                            Text(step.description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .tabViewStyle(.page) // This adds the swipe dots at the bottom
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Button("Start Playing") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.bottom, 50)
            }
        }
    }
}
