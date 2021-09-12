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
    
    func addShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 3
        layer.shadowOpacity = 1
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
    
    func shakeAnimation(duration: TimeInterval = 0.5, xValue: CGFloat = 2, yValue: CGFloat = 7) {
           self.transform = CGAffineTransform(translationX: xValue, y: yValue)
           UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
               self.transform = CGAffineTransform.identity
           }, completion: nil)

       }
    
    func activityStartAnimating() {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = .clear
        backgroundView.tag = 475647

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .customLightBlue
        self.addSubview(backgroundView)
        backgroundView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        
        activityIndicator.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
    }

    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}
