//
//  AuthViewModel.swift
//  project
//
//  Created by user279102 on 11/3/25.
//

import SwiftUI
import Combine
import AuthenticationServices

@MainActor
final class AuthViewModel: ObservableObject {
@Published var email: String = ""
@Published var password: String = ""
@Published var isLoading = false
@Published var errorMessage: String?


private let authService: AuthServiceProtocol
private var onAuthChanged: ((Bool) -> Void)?


init(authService: AuthServiceProtocol, onAuthChanged: ((Bool) -> Void)? = nil) {
self.authService = authService
self.onAuthChanged = onAuthChanged
}


func bindAuthChanged(_ handler: @escaping (Bool) -> Void) { self.onAuthChanged = handler }


func login() async {
await runAuth { [self] in
_ = try await authService.signIn(email: email, password: password)
onAuthChanged?(true)
}
}


func signUp() async {
await runAuth { [self] in
_ = try await authService.signUp(email: email, password: password)
onAuthChanged?(true)
}
}


func signOut() async {
await runAuth { [self] in
try await authService.signOut()
onAuthChanged?(false)
}
}


func appleCompletion(_ result: Result<ASAuthorization, Error>) async {
await runAuth { [self] in
_ = try await authService.handleAppleCompletion(result)
onAuthChanged?(true)
}
}


func configureAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
authService.makeAppleRequest(request)
}


private func runAuth(_ block: @escaping () async throws -> Void) async {
errorMessage = nil
isLoading = true
defer { isLoading = false }
do { try await block() } catch { errorMessage = error.localizedDescription }
}
}
