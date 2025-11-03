//
//  FirebaseAuthService.swift
//  project
//
//  Created by user279102 on 11/3/25.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit

@MainActor
final class FirebaseAuthService: AuthServiceProtocol {
    private var currentNonce: String?

    // MARK: - Session

    func currentUser() async -> UserSession? {
        if let user = Auth.auth().currentUser {
            return UserSession(id: user.uid, email: user.email)
        }
        return nil
    }

    func signIn(email: String, password: String) async throws -> UserSession {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = result.user
        return UserSession(id: user.uid, email: user.email)
    }

    func signUp(email: String, password: String) async throws -> UserSession {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = result.user
        return UserSession(id: user.uid, email: user.email)
    }

    func signOut() async throws {
        try Auth.auth().signOut()
    }

    // MARK: - Apple Sign-In

    func makeAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }

    func handleAppleCompletion(_ result: Result<ASAuthorization, Error>) async throws -> UserSession {
        switch result {
        case .failure(let error):
            throw error

        case .success(let auth):
            guard let appleID = auth.credential as? ASAuthorizationAppleIDCredential else {
                throw NSError(
                    domain: "apple.auth",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Credencial inválida"]
                )
            }

            guard let nonce = currentNonce else {
                throw NSError(
                    domain: "apple.auth",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Nonce ausente"]
                )
            }

            guard
                let appleIDToken = appleID.identityToken,
                let idTokenString = String(data: appleIDToken, encoding: .utf8)
            else {
                throw NSError(
                    domain: "apple.auth",
                    code: -3,
                    userInfo: [NSLocalizedDescriptionKey: "Token inválido"]
                )
            }

            // ✅ API nova do FirebaseAuth (substitui a antiga indisponível)
            let credential = OAuthProvider.appleCredential(
                withIDToken: idTokenString,
                rawNonce: nonce,
                fullName: appleID.fullName
            )

            let authResult = try await Auth.auth().signIn(with: credential)
            let user = authResult.user
            return UserSession(id: user.uid, email: user.email)
        }
    }
}

// MARK: - Nonce Utils

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashed = SHA256.hash(data: inputData)
    return hashed.map { String(format: "%02x", $0) }.joined()
}

private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
        // usa bytes aleatórios do sistema
        var randoms = [UInt8](repeating: 0, count: 16)
        let status = SecRandomCopyBytes(kSecRandomDefault, randoms.count, &randoms)
        if status != errSecSuccess {
            // fallback (raro)
            randoms = (0..<16).map { _ in UInt8.random(in: 0...255) }
        }

        randoms.forEach { random in
            if remainingLength == 0 { return }
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    return result
}
