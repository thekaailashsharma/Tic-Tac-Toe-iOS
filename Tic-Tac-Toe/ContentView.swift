//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Kailash on 20/09/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var mainViewModel = MainViewModel()
    
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
                                    .degrees(mainViewModel.currentPlayer == .human ? 0 : 90),
                                    axis: (x: 1.0, y: 0.0, z: 0.0)
                                )
                                .opacity(mainViewModel.currentPlayer == .human  ? 1 : 0)
                                .animation(.linear(duration: 0.5))
                        }
                        Spacer()
                        Text("X")
                            .font(.title)
                            .foregroundColor(mainViewModel.currentPlayer == .human ? .green : .white)
                        Spacer()
                        Text("V/S")
                            .font(.title3)
                        Spacer()
                        Text("0")
                            .font(.title)
                            .foregroundColor(
                                mainViewModel.currentPlayer == .computer ? .green : .white)
                        Spacer()
                        VStack {
                            TurnHeader(player: .constant(.computer))
                            Text("AI's Turn")
                                .font(.title2)
                                .foregroundColor(.green)
                                .rotation3DEffect(
                                    .degrees(mainViewModel.currentPlayer == .human  ? -90 : 0),
                                    axis: (x: 1.0, y: 0.0, z: 0.0)
                                )
                                .opacity(mainViewModel.currentPlayer == .human  ? 0 : 1)
                                .animation(.linear(duration: 0.5))
                        }
                        
                    }.padding()
                    Spacer()
                    LazyVGrid(columns: mainViewModel.columns, spacing: 5) {
                        ForEach(0..<9) {index in
                            ZStack {
                                CardView(isFlipped: $mainViewModel.isFlipped[index], moves: $mainViewModel.moves, index: index)
                                    .frame(width: geometry.size.width / 3 - 15, height: geometry.size.width / 3 - 15)
                                    .onTapGesture {
                                        withAnimation(Animation.linear(duration: 0.5)) {
                                            if mainViewModel.moves[index] == nil {
                                                mainViewModel.currentPlayer = .human
                                                mainViewModel.isFlipped[index].toggle()
                                                mainViewModel.moves[index] = Move(player: .human, boardIndex: index)
                                                if mainViewModel.checkWinCondition(for: .human, in:   mainViewModel.moves){
                                                    print("Human Wins")
                                                    mainViewModel.isAnimationVisible = true
                                                    mainViewModel.winningPlayer = .human
                                                    return
                                                }
                                                if mainViewModel.checkDrawCondition(in: mainViewModel.moves){
                                                    print("Draw")
                                                    mainViewModel.isAnimationVisible = true
                                                    mainViewModel.winningPlayer = nil
                                                    return
                                                }
                                                mainViewModel.aiCardIndex = mainViewModel.determineAIposition(in: mainViewModel.moves)
                                                mainViewModel.currentPlayer = .computer
                                                
                                                mainViewModel.isGameBoardDisabled = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                                    if(mainViewModel.aiCardIndex != nil){
                                                        mainViewModel.isFlipped[mainViewModel.aiCardIndex!].toggle()
                                                        mainViewModel.moves[mainViewModel.aiCardIndex!] = Move(player: .computer, boardIndex: mainViewModel.aiCardIndex!)
                                                        mainViewModel.aiCardIndex = nil
                                                        mainViewModel.isGameBoardDisabled = false
                                                        mainViewModel.currentPlayer = .human
                                                        if mainViewModel.checkWinCondition(for: .computer, in:   mainViewModel.moves){
                                                            print("AI Wins")
                                                            mainViewModel.isAnimationVisible = true
                                                            mainViewModel.winningPlayer = .computer
                                                            return
                                                        }
                                                        if mainViewModel.checkDrawCondition(in: mainViewModel.moves){
                                                            print("Draw")
                                                            mainViewModel.isAnimationVisible = true
                                                            mainViewModel.winningPlayer = nil
                                                            return
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                Image(systemName: mainViewModel.moves[index]?.indicator ?? "")
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
                .disabled(mainViewModel.isGameBoardDisabled)
                .blur(radius: mainViewModel.isAnimationVisible ? 5: 0)
                
                if(mainViewModel.isAnimationVisible){
                    ZStack {
                        VStack {
                            Spacer()
                            if(mainViewModel.winningPlayer == nil){
                                MyLottieAnimation(url: Bundle.main.url(forResource: "draw", withExtension: "lottie")!)
                                    .scaledToFit()
                            } else {
                                MyLottieAnimation(url: Bundle.main.url(forResource: mainViewModel.winningPlayer == .human ? "wins": "loose" , withExtension: "lottie")!)
                                    .scaledToFit()
                            }
                            Spacer()
                        }.frame(width: 400, height: 400)
                        if mainViewModel.winningPlayer == .human {
                            MyLottieAnimation(url: Bundle.main.url(forResource: "confetti", withExtension: "lottie")!,
                                              loopMode: .playOnce)
                            .scaledToFit()
                        }
                        
                    }
                }
                
                VStack {
                    Spacer()
                    Button(action: {
                        mainViewModel.moves = Array(repeating: nil, count: 9)
                        mainViewModel.isFlipped = Array(repeating: false,count: 9)
                        mainViewModel.isAnimationVisible = false
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
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}






