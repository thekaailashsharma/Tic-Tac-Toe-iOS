//
//  FlipView.swift
//  Tic-Tac-Toe
//
//  Created by Admin on 20/09/23.
//

import SwiftUI

struct CardView: View {
    @Binding var isFlipped: Bool
    @Binding var moves: [Move?]
    let index: Int
    
    
    var body: some View {
        Circle()
            .foregroundColor(isFlipped ? Color.red.opacity(0.8) : Color.green.opacity(0.8))
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .scaleEffect(isFlipped ? 0.8 : 1.0)
        
    }
}
