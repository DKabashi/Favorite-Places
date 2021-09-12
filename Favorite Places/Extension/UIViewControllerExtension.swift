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
    
    func presentAlert(title: String, message: String, buttonTitle: String = "Close") {
        DispatchQueue.main.async {
            let alertVC = FavoritePlacesAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentAlertWithTwoOptions(title: String = "Informatë", message: String, buttonTitle: String, alternativeButtonTitle: String? = nil, buttonCallback: (()->())? = nil, alternativeButtonCallback: (() -> ())? = nil){
        DispatchQueue.main.async {
            let alertVC = FavoritePlacesAlertViewController(title: title, message: message, buttonTitle: buttonTitle, alternativeButtonTitle: alternativeButtonTitle, buttonCallback: buttonCallback, alternativeButtonCallback: alternativeButtonCallback)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }

}
