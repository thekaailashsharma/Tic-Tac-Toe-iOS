//
//  MainViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Admin on 21/09/23.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isFlipped: [Bool] = Array(repeating: false,count: 9)
    @Published var aiCardIndex: Int? = nil
    @Published var isGameBoardDisabled = false
    @Published var currentPlayer: Player = .human
    @Published var winningPlayer: Player? = nil
    @Published var isAnimationVisible = false
    
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {
            $0?.boardIndex == index
        })
    }

    func determineAIposition(in moves: [Move?]) -> Int {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6],[1,4,7],[2,5,8], [0,4,8], [2,4,6]]

        // Check for winning moves first
        if let winningMove = findWinningMove(for: .computer, in: moves, with: winPatterns) {
            return winningMove
        }

        // Check for blocking moves
        if let blockingMove = findWinningMove(for: .human, in: moves, with: winPatterns) {
            return blockingMove
        }

        // If no winning or blocking moves, make a random move
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }

    func findWinningMove(for player: Player, in moves: [Move?], with winPatterns: Set<Set<Int>>) -> Int? {
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })

        for pattern in winPatterns {
            let winPositions = pattern.subtracting(playerPositions)

            if winPositions.count == 1 {
                let movePosition = winPositions.first!
                if !isSquareOccupied(in: moves, forIndex: movePosition) {
                    return movePosition
                }
            }
        }

        return nil
    }


    func checkWinCondition(for player: Player, in move: [Move?]) -> Bool {
        
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6],[1,4,7],[2,5,8], [0,4,8], [2,4,6]]
        
        let playerMoves = moves.compactMap{$0}.filter{$0.player == player}
        
        let playerPositions = Set(playerMoves.map{$0.boardIndex})
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){
            return true
        }
        
        return false
    }
    
    func checkDrawCondition(in moves: [Move?]) -> Bool {
        return moves.compactMap{$0}.count == 9
    }
    
    
}
