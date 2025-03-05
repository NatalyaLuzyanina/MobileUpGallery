//
//  LoginViewModel.swift
//  mobileUpGallery
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

import Foundation

final class LoginViewModel: ObservableObject, ToastViewUsable {
    @Published var isToastViewDisplayed = false
    @Published var toastMessage = ""

    private let coordinator: LoginCoordinator<LoginViewController>
    private let authRepository = AuthRepository()

    init(coordinator: LoginCoordinator<LoginViewController>) {
        self.coordinator = coordinator
    }

    func handleTapOnLogin() {
        authRepository.startAuthSession { [weak self] in
            switch $0 {
            case .success:
                self?.coordinator.openRootTabBarController()
            case .failure:
                self?.showToastWithMessage(R.string.login.loginError())
            }
        }
    }
}
