//
//  PlayerScore.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-23.
//

//Codable allows this data to be converted into a format that can be saved

import Foundation

struct PlayerScore: Identifiable, Codable {
    var id = UUID()
    let name: String
    let score: Int
    let mode: String
    let date: Date
}


