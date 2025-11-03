//
//  LoginView.swift
//  project
//
//  Created by user279102 on 11/3/25.
//
//
//  LoginView.swift
//  ScreenRoom
//

import SwiftUI
import AuthenticationServices
import Combine

struct LoginView: View {
    @StateObject var viewModel: AuthViewModel
    var onAuthChanged: (Bool) -> Void

    init(viewModel: AuthViewModel, onAuthChanged: @escaping (Bool) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onAuthChanged = onAuthChanged
        viewModel.bindAuthChanged(onAuthChanged)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, Color(red: 0.08, green: 0.08, blue: 0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                header
                form
                actions
                Spacer(minLength: 12)
            }
            .padding(24)

            if viewModel.isLoading {
                ProgressView().tint(.white)
            }
        }
        .alert(
            "Erro",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: 10) {
            Image("Logo") // opcional, seu ícone
                .resizable()
                .frame(width: 72, height: 72)
                .cornerRadius(16)
                .shadow(
                    color: SRColors.neonBlue.opacity(0.4),
                    radius: 20, x: 0, y: 10
                )

            Text("Bem-vindo ao Screenroom")
                .font(.title.bold())
                .foregroundStyle(.white.opacity(0.95))

            Text("Registre o que assiste. Converse ao vivo. Sem spoilers.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.bottom, 6)
    }

    private var form: some View {
        VStack(spacing: 14) {
            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .textFieldStyle(NeonFieldStyle())

            SecureField("Senha", text: $viewModel.password)
                .textFieldStyle(NeonFieldStyle())
        }
    }

    private var actions: some View {
        VStack(spacing: 14) {
            PrimaryButton(title: "Entrar") {
                Task { await viewModel.login() }
            }
            .disabled(viewModel.email.isEmpty || viewModel.password.count < 6)

            Button {
                Task { await viewModel.signUp() }
            } label: {
                Text("Criar Conta")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.vertical, 8)
            }

            AppleSignInButton { request in
                viewModel.configureAppleRequest(request)
            } onCompletion: { result in
                Task { await viewModel.appleCompletion(result) }
            }
            .padding(.top, 6)
        }
        .padding(.top, 4)
    }
}
