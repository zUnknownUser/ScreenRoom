//
//  AppContainer.swift
//  project
//
//  Created by user279102 on 11/3/25.
//

import Foundation


final class AppContainer {
static let shared = AppContainer()
private init() {}


// Services
let authService: AuthServiceProtocol = FirebaseAuthService()
}
