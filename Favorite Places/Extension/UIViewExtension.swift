//
//  UIViewExtension.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit

extension UIView {
    func add(_ childView: UIView) {
        addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pinToEdges(of superview: UIView, topPadding: CGFloat = 0, horizontalPadding: CGFloat = 0, bottomPadding: CGFloat = 0) {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: topPadding).isActive = true
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: horizontalPadding).isActive = true
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -horizontalPadding).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomPadding).isActive = true
        
    }
    
    func clickAnimation(){
        UIView.animate(withDuration: 0.1,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform.identity
                }
            })
    }
}
