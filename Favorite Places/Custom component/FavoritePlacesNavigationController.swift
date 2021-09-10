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
        isNavigationBarHidden = true
        viewControllers = [LandingViewController()]
    }
}
