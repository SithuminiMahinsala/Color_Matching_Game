//
//  MenuView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-16.
//

import SwiftUI

struct MenuView: View {
    var body: some View{
        //to move between screens
        NavigationStack {
            VStack(spacing: 20) {
                Text("Color Snap")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                // Easy mode (3*3)
                NavigationLink(destination: GameView(gridSize: 3)) {
                    Text("Easy")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                //Medium mode (5*5)
                NavigationLink(destination: GameView(gridSize: 5)) {
                    Text("Medium")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                //Hard mode (7*7)
                NavigationLink(destination: GameView(gridSize: 7)) {
                    Text("Hard")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
    }
}
