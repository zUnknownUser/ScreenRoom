//
//  AuthServiceProtocol.swift
//  project
//
//  Created by user279102 on 11/3/25.
//

import AuthenticationServices


@MainActor
protocol AuthServiceProtocol {
func currentUser() async -> UserSession?
func signIn(email: String, password: String) async throws -> UserSession
func signUp(email: String, password: String) async throws -> UserSession
func signOut() async throws


// Apple Sign-In
func makeAppleRequest(_ request: ASAuthorizationAppleIDRequest)
func handleAppleCompletion(_ result: Result<ASAuthorization, Error>) async throws -> UserSession
}
