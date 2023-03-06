//
//  Extension.swift
//  movies
//
//  Created by Oleksandr Khalypa on 02.02.2023.
//

import UIKit

extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.opacity = 0.9
        addSubview(blurEffectView)
    }
}

extension UIView {
    func addShadow() {
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
    }
}
