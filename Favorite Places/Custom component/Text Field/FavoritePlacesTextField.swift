//
//  FavoritePlacesTextField.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritePlacesTextField: UITextField {
    private let toggleTextEntryVisibilityButton = UIButton(type: .custom)
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .customTextFieldBlue
        layer.cornerRadius = .defaultCornerRadius
        font = .systemFont(ofSize: 28)
        let paddingRect = CGRect(x: 0, y: 0, width: 20, height: 30)
        leftView = UIView(frame: paddingRect)
        leftViewMode = .always
        rightView = UIView(frame: paddingRect)
        rightViewMode = .always
        autocorrectionType = .no
        autocapitalizationType = .none
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func configureForPassword() {
        isSecureTextEntry = true
        toggleTextEntryVisibilityButton.setImage(.eyeClosed, for: .normal)
        toggleTextEntryVisibilityButton.tintColor = .gray
        toggleTextEntryVisibilityButton.frame = CGRect(x: 10, y: 0, width: 30, height: 40)
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        rightView?.addSubview(toggleTextEntryVisibilityButton)
        rightViewMode = .always
        observeToggleTextEntryVisibilityButton()
    }
    
    private func observeToggleTextEntryVisibilityButton() {
        toggleTextEntryVisibilityButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.isSecureTextEntry{
                self.isSecureTextEntry = false
                self.toggleTextEntryVisibilityButton.setImage(.eyeOpened, for: .normal)
            }else{
                self.isSecureTextEntry = true
                self.toggleTextEntryVisibilityButton.setImage(.eyeClosed, for: .normal)
            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
