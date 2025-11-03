//
//  ScreenRoomApp.swift
//  project
//
//  Created by user279102 on 11/3/25.
//

import SwiftUI
import FirebaseCore


@main
struct ScreenRoomApp: App {
    @StateObject private var coordinator: AppCoordinator

    init() {
        _coordinator = StateObject(
            wrappedValue: AppCoordinator(authService: AppContainer.shared.authService)
        )
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            switch coordinator.phase {
            case .splash:
                SplashView()

            case .unauthenticated:
                let vm = AuthViewModel(authService: AppContainer.shared.authService)
                LoginView(viewModel: vm) { loggedIn in
                    coordinator.handleAuthChange(isLoggedIn: loggedIn)
                }

            case .authenticated:
                Text("✅ Logado no ScreenRoom!")
                    .font(.title.bold())
                    .padding()
            }
        }
    }
}
