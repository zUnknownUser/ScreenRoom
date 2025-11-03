//
//  RootCoordinator.swift
//  project
//
//  Created by user279102 on 11/3/25.
//

import SwiftUI
import Combine

@MainActor
final class RootCoordinator: ObservableObject {
enum Phase { case splash, unauthenticated, authenticated }


@Published var phase: Phase = .splash


private let authService: AuthServiceProtocol


init(authService: AuthServiceProtocol) {
self.authService = authService
Task { await bootstrap() }
}


func bootstrap() async {
// pequena animação de splash + checagem de sessão
try? await Task.sleep(nanoseconds: 1_200_000_000)
if await authService.currentUser() != nil {
phase = .authenticated
} else {
phase = .unauthenticated
}
}


func handleAuthChange(isLoggedIn: Bool) {
withAnimation(.spring()) {
phase = isLoggedIn ? .authenticated : .unauthenticated
}
}
}
