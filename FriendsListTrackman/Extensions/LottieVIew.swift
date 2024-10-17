//
//  LottieVIew.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 16.10.24.
//

import UIKit
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    var animationFileName: String
    let loopMode: LottieLoopMode
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animationFileName)
        animationView.loopMode = loopMode
        animationView.play()
        animationView.contentMode = .scaleAspectFit
        return animationView
    }
}
