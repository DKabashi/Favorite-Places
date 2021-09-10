//
//  SignupViewController.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/10/21.
//

import UIKit
import RxCocoa
import RxSwift

class SignupViewController: UIViewController {
    
    let authenticationView = AuthenticationView(isLogin: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAuthenticationView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupAuthenticationView() {
        view.add(authenticationView)
        authenticationView.pinToEdges(of: view, topPadding: .padding * 4, bottomPadding: .padding * 3)
    }
}
