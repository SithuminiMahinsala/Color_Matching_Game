//
//  LandingView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-26.
//

import SwiftUI

struct LandingView: View {
    // State to control navigation to the main menu
    @State private var isActive = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // --- Game Branding Section ---
                VStack(spacing: 25) {
                    // This uses the icon you generated. Ensure you named it "AppIconImage" in Assets
                    Image("AppIconImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .cornerRadius(45)
                        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                    
                    VStack(spacing: 8) {
                        Text("Color Snap")
                            .font(.system(size: 52, weight: .black, design: .rounded))
                        
                        Text("MASTER YOUR MEMORY")
                            .font(.subheadline.bold())
                            .tracking(3)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // --- Primary Action ---
                NavigationLink(destination: MenuView()) {
                    Text("PLAY GAME")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                           startPoint: .top, endPoint: .bottom)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(18)
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                
                // --- Legal Links Section ---
                HStack(spacing: 25) {
                    NavigationLink(destination: PrivacyView()) {
                        Text("Privacy Policy")
                    }
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: TermsOfServiceView()) {
                        Text("Terms & Service")
                    }
                }
                .font(.footnote.bold())
                .foregroundColor(.blue)
                .padding(.top, 30)
                .padding(.bottom, 20)
            }
            .background(
                Color(.systemBackground).ignoresSafeArea()
            )
        }
    }
}
