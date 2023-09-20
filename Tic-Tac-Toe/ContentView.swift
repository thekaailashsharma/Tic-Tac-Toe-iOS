//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Admin on 20/09/23.
//

import SwiftUI

struct ContentView: View {
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isFlipped: [Bool] = Array(repeating: false,count: 9)
    @State private var aiCardIndex: Int? = nil
    @State private var isGameBoardDisabled = false
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<9) {index in
                        ZStack {
                            CardView(isFlipped: $isFlipped[index], moves: $moves, index: index)
                                .frame(width: geometry.size.width / 3 - 15, height: geometry.size.width / 3 - 15)
                                .onTapGesture {
                                    withAnimation(Animation.linear(duration: 0.5)) {
                                        if moves[index] == nil {
                                            isFlipped[index].toggle()
                                            moves[index] = Move(player: .human, boardIndex: index)
                                            if checkWinCondition(for: .human, in:   moves){
                                                print("Human Wins")
                                                return
                                            }
                                            aiCardIndex = determineAIposition(in: moves)
                                            
                                            isGameBoardDisabled = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                                if(aiCardIndex != nil){
                                                    isFlipped[aiCardIndex!].toggle()
                                                    moves[aiCardIndex!] = Move(player: .computer, boardIndex: aiCardIndex!)
                                                    aiCardIndex = nil
                                                    isGameBoardDisabled = false
                                                    if checkWinCondition(for: .computer, in:   moves){
                                                        print("AI Wins")
                                                        return
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            Image(systemName:moves[index]?.indicator ?? "")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.85))
                            
                            
                            
                            
                        }
                        .foregroundColor(.green)
                        
                    }
                    
                }
                Spacer()
            }
            .padding()
            .disabled(isGameBoardDisabled)
        }
        
    }
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {
            $0?.boardIndex == index
        })
    }

    func determineAIposition(in moves: [Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
        while(isSquareOccupied(in: moves, forIndex: movePosition)){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}






