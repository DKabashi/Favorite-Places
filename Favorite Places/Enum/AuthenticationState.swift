//
//  AuthenticationState.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/11/21.
//

import Foundation

enum AuthenticationState {
    case success(user: User?),
         fail(error: Error)
}
