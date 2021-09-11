//
//  AuthenticationManager.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

class AuthenticationManager {
    let state = PublishRelay<AuthenticationState>()
    private var handle: AuthStateDidChangeListenerHandle?
    
    static var isAuthenticated: Bool {
        return Auth.auth().currentUser != nil
    }
    
    init() {
        observeUserStateChanges()
    }
    
    private func observeUserStateChanges() {
        handle = Auth.auth().addStateDidChangeListener({[weak self] _, user in
            guard let self = self else { return }
            guard let email = user?.email else {
                self.state.accept(.success(user: nil))
                return
            }
            let user = User(email: email)
            self.state.accept(.success(user: user))
        })
    }

    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.state.accept(.fail(error: error))
            } else {
                self.signinUser(email: email, password: password)
            }
        }
    }
    
    func signinUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.state.accept(.fail(error: error))
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            
        } catch let error {
            self.state.accept(.fail(error: error))
        }
       
    }
    
    deinit {
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
}
