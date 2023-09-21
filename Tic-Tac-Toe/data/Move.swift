//
//  Move.swift
//  Tic-Tac-Toe
//
//  Created by Admin on 21/09/23.
//

import SwiftUI

struct Move {
    let player: Player
    let boardIndex: Int
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
