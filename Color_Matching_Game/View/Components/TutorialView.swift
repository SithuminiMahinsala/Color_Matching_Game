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
    
    // Persistent storage for the username
    @AppStorage("username") private var username: String = ""
    
    // State to track which page the user is on
    @State private var currentStep = 0
    
    let steps = [
        TutorialStep(title: "Match Colors", description: "Tap tiles to find matching colors. Clear the board to win!", icon: "paintpalette.fill", color: .blue),
        TutorialStep(title: "Save Flips", description: "Every flip left at the end adds 10 bonus points to your score!", icon: "star.circle.fill", color: .orange),
        TutorialStep(title: "Your Profile", description: "Set your name once to track your wins and climb the leaderboard.", icon: "person.crop.circle.badge.checkmark", color: .green)
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentStep) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            Image(systemName: steps[index].icon)
                                .font(.system(size: 80))
                                .foregroundColor(steps[index].color)
                            
                            VStack(spacing: 15) {
                                Text(steps[index].title)
                                    .font(.largeTitle.bold())
                                
                                Text(steps[index].description)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                    .foregroundColor(.secondary)
                            }
                            
                            // SHOW TEXTFIELD ONLY ON THE LAST STEP
                            if index == steps.count - 1 {
                                VStack(spacing: 10) {
                                    TextField("Enter your name", text: $username)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .multilineTextAlignment(.center)
                                        .font(.title3)
                                        .padding(.horizontal, 50)
                                        .submitLabel(.done)
                                    
                                    if username.isEmpty {
                                        Text("Please enter a name to continue")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.top, 20)
                                .transition(.opacity) 
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                // BUTTON LOGIC
                Button(action: {
                    if currentStep < steps.count - 1 {
                        withAnimation { currentStep += 1 }
                    } else {
                        dismiss()
                    }
                }) {
                    Text(currentStep == steps.count - 1 ? "Let's Play!" : "Next")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isButtonDisabled ? Color.gray : .blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .disabled(isButtonDisabled)
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
    
    // Validation logic
    private var isButtonDisabled: Bool {
        return currentStep == steps.count - 1 && username.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
