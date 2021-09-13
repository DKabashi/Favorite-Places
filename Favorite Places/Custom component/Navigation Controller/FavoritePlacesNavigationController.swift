//
//  FavoritePlacesNavigationController.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit

class FavoritePlacesNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = UIColor.clear
        navigationBar.tintColor = .customLightBlue
        navigationItem.backBarButtonItem?.title = ""
        if AuthenticationManager.isAuthenticated {
            viewControllers = [MapViewController()]
        } else {
            viewControllers = [LandingViewController()]
        }
    }
    
}
