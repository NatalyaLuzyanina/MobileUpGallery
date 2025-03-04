//
//  LoginView.swift
//  mobileUpGallery
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            Text(R.string.login.loginTitle())
                .font(.titleLarge)
                .padding(.top, 150)
            Spacer()
            ToastView(isPresented: $viewModel.isToastViewDisplayed, message: viewModel.toastMessage)
            GenericButton(styleType: .primary, title: R.string.login.loginButtonTitle()) {
                viewModel.handleTapOnLogin()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    LoginView(viewModel: LoginViewModel(coordinator: LoginCoordinator()))
}
