//
//  CellView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-16.
//

import SwiftUI

struct CellView: View {
    let cell: GridCell
    
    var body: some View {
        ZStack {
            // BACK of the card (Visible when NOT selected/flipped)
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .overlay(
                    Image(systemName: "questionmark.circle")
                        .font(.title)
                        .foregroundColor(.white.opacity(0.5))
                )
                // If it is selected OR matched, hide the back
                .opacity(cell.isSelected || cell.isMatched ? 0 : 1)
            
            // FRONT of the card (Visible when selected or matched)
            RoundedRectangle(cornerRadius: 12)
                .fill(cell.color)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
                // If it is selected OR matched, show the color
                .opacity(cell.isSelected || cell.isMatched ? 1 : 0)
        }
        // --- The 3D Flip Animation ---
        .rotation3DEffect(
            .degrees(cell.isSelected || cell.isMatched ? 180 : 0),
            axis: (x: 0, y: 1, z: 0) // Flips horizontally on the Y-axis
        )
        // Ensures content (like icons) isn't mirrored when flipped
        .rotation3DEffect(
            .degrees(cell.isSelected || cell.isMatched ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        // Adds a bouncy spring effect to the movement
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: cell.isSelected)
        .aspectRatio(1, contentMode: .fit)
    }
}

