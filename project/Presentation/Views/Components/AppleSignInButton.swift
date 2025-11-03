//
//  AppleSignInButton.swift
//  project
//
//  Created by user279102 on 11/3/25.
//

import SwiftUI
import AuthenticationServices


struct AppleSignInButton: View {
let onRequest: (ASAuthorizationAppleIDRequest) -> Void
let onCompletion: (Result<ASAuthorization, Error>) -> Void


var body: some View {
SignInWithAppleButton(.signIn) { request in
onRequest(request)
} onCompletion: { result in
onCompletion(result)
}
.signInWithAppleButtonStyle(.whiteOutline)
.frame(height: 52)
.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
.overlay(
RoundedRectangle(cornerRadius: 16)
.stroke(LinearGradient(colors: [SRColors.neonPink, SRColors.neonBlue], startPoint: .leading, endPoint: .trailing), lineWidth: 1.2)
)
.shadow(color: SRColors.neonBlue.opacity(0.35), radius: 10, x: 0, y: 6)
}
}
