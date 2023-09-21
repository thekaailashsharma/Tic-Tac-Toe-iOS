//
//  TurnHeader.swift
//  Tic-Tac-Toe
//
//  Created by Admin on 21/09/23.
//

import SwiftUI
import Lottie

struct TurnHeader: View {
    @Binding var player: Player
    var body: some View {
        
        VStack {
            ZStack {
                MyLottieAnimation(url: Bundle.main.url(forResource: player == .computer ? "computer" : "human", withExtension: "lottie")!)
                    .offset(x: 0, y: -20)
                    .scaledToFill()
                    .frame(width: 80, height: 80)
            }.frame(width: 60, height: 60)
            

            
        }
        
    }
}

struct TurnHeader_Previews: PreviewProvider {
    static var previews: some View {
        TurnHeader(player: .constant(.computer))
    }
}
