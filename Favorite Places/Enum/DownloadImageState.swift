//
//  DownloadImageState.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/12/21.
//

import UIKit

enum DownloadImageState {
    case downloading,
         error,
         success(image: UIImage)
}
