//
//  UIScreenExtension.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/13/21.
//

import UIKit


extension UIScreen {
    static let isIphone8Size = max(main.bounds.size.width, main.bounds.size.height) <= 667.0
    static let isIphone8PlusSizeOrLower = max(main.bounds.size.width, main.bounds.size.height) <= 736.0
    
}
