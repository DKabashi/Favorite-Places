//
//  UIViewControllerExtension.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import UIKit

extension UIViewController {
    
    func switchRootViewController() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = FavoritePlacesNavigationController()
        }
    }
}
