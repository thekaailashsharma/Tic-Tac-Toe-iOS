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
    @State private var currentPlayer: Player = .human
    @State private var winningPlayer: Player? = nil
    @State private var isAnimationVisible = false
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack(alignment: .top) {
                        VStack {
                            TurnHeader(player: .constant(.human))
                            Text("Your Turn")
                                .font(.title2)
                                .foregroundColor(.green)
                                .rotation3DEffect(
                                    .degrees(currentPlayer == .human ? 0 : 90),
                                    axis: (x: 1.0, y: 0.0, z: 0.0)
                                )
                                .opacity(currentPlayer == .human  ? 1 : 0)
                                .animation(.linear(duration: 0.5))
                        }
                        Spacer()
                        Text("X")
                            .font(.title)
                            .foregroundColor(currentPlayer == .human ? .green : .white)
                        Spacer()
                        Text("V/S")
                            .font(.title3)
                        Spacer()
                        Text("0")
                            .font(.title)
                            .foregroundColor(
                                currentPlayer == .computer ? .green : .white)
                        Spacer()
                        VStack {
                            TurnHeader(player: .constant(.computer))
                            Text("AI's Turn")
                                .font(.title2)
                                .foregroundColor(.white)
                                .rotation3DEffect(
                                    .degrees(currentPlayer == .human  ? -90 : 0),
                                    axis: (x: 1.0, y: 0.0, z: 0.0)
                                )
                                .opacity(currentPlayer == .human  ? 0 : 1)
                                .animation(.linear(duration: 0.5))
                        }
                        
                    }.padding()
                    Spacer()
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(0..<9) {index in
                            ZStack {
                                CardView(isFlipped: $isFlipped[index], moves: $moves, index: index)
                                    .frame(width: geometry.size.width / 3 - 15, height: geometry.size.width / 3 - 15)
                                    .onTapGesture {
                                        withAnimation(Animation.linear(duration: 0.5)) {
                                            if moves[index] == nil {
                                                currentPlayer = .human
                                                isFlipped[index].toggle()
                                                moves[index] = Move(player: .human, boardIndex: index)
                                                if checkWinCondition(for: .human, in:   moves){
                                                    print("Human Wins")
                                                    isAnimationVisible = true
                                                    winningPlayer = .human
                                                    return
                                                }
                                                if checkDrawCondition(in: moves){
                                                    print("Draw")
                                                    isAnimationVisible = true
                                                    winningPlayer = nil
                                                    return
                                                }
                                                aiCardIndex = determineAIposition(in: moves)
                                                currentPlayer = .computer
                                                
                                                isGameBoardDisabled = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                                    if(aiCardIndex != nil){
                                                        isFlipped[aiCardIndex!].toggle()
                                                        moves[aiCardIndex!] = Move(player: .computer, boardIndex: aiCardIndex!)
                                                        aiCardIndex = nil
                                                        isGameBoardDisabled = false
                                                        currentPlayer = .human
                                                        if checkWinCondition(for: .computer, in:   moves){
                                                            print("AI Wins")
                                                            isAnimationVisible = true
                                                            winningPlayer = .computer
                                                            return
                                                        }
                                                        if checkDrawCondition(in: moves){
                                                            print("Draw")
                                                            isAnimationVisible = true
                                                            winningPlayer = nil
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
                    Spacer()
                }
                .padding()
                .disabled(isGameBoardDisabled)
                .blur(radius: isAnimationVisible ? 5: 0)
                
                if(isAnimationVisible){
                    ZStack {
                        VStack {
                            Spacer()
                            if(winningPlayer == nil){
                                MyLottieAnimation(url: Bundle.main.url(forResource: "draw", withExtension: "lottie")!)
                                    .scaledToFit()
                            } else {
                                MyLottieAnimation(url: Bundle.main.url(forResource: winningPlayer == .human ? "wins": "loose" , withExtension: "lottie")!)
                                    .scaledToFit()
                            }
                            Spacer()
                        }.frame(width: 400, height: 400)
                        if winningPlayer == .human {
                            MyLottieAnimation(url: Bundle.main.url(forResource: "confetti", withExtension: "lottie")!,
                                              loopMode: .playOnce)
                            .scaledToFit()
                        }
                        
                    }
                }
                
                VStack {
                    Spacer()
                    Button(action: {
                        moves = Array(repeating: nil, count: 9)
                        isFlipped = Array(repeating: false,count: 9)
                        isAnimationVisible = false
                    }){
                        Text("Play Again")
                            .font(.title)
                    }
                    .padding(.bottom)
                    .buttonStyle(.bordered)
                    .tint(.green)
                }
                
            }
        }
        
    }
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






