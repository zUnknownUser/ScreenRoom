//
//  AppCoordinator.swift
//  project
//
//  Created by user279102 on 11/3/25.
//

// App/AppCoordinator.swift
import SwiftUI
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    enum Phase { case splash, unauthenticated, authenticated }

    @Published var phase: Phase = .splash
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
        Task { await bootstrap() }
    }

    private func bootstrap() async {
        // Splash curto + checagem de sessão
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

