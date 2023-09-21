//
//  TurnCard.swift
//  Tic-Tac-Toe
//
//  Created by Admin on 21/09/23.
//

import SwiftUI
import Lottie


struct MyLottieAnimation: UIViewRepresentable {
    
    let url: URL
    var loopMode: LottieLoopMode = .repeat(2)
    
    
    func makeUIView(context: Context) -> some UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            
            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
        ])
        
        DotLottieFile.loadedFrom(url: url) {
            result in switch result {
            case .success(let success):
                animationView.loadAnimation(from: success)
                animationView.loopMode = loopMode
                animationView.play()
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
}


