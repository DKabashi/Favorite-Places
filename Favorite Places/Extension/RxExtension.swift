//
//  RxExtension.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import Foundation
import RxSwift
import RxCocoa

extension UIView {
    func observeTap() -> ControlEvent<UITapGestureRecognizer> {
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)
        return tapGesture.rx.event
    }
    
    func observeLongPress() -> ControlEvent<UILongPressGestureRecognizer> {
        let longPressGesture = UILongPressGestureRecognizer()
        addGestureRecognizer(longPressGesture)
        return longPressGesture.rx.event
    }
}
