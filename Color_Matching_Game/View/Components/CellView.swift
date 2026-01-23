//
//  CellView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-16.
//

import SwiftUI
struct CellView: View {
    var cell: GridCell
    
    var body: some View {
        Rectangle()
            .fill(cell.isMatched || cell.isSelected ? cell.color : Color.gray)
            //.opacity(cell.isSelected || cell.isMatched ? 1 : 0.7)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(10)
            .shadow(radius: 2)
            .animation(.easeInOut(duration: 0.2), value: cell.isSelected)
    }
}

