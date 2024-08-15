//
//  LoginWebViewPresenter.swift
//  MobileUpGallery
//
//  Created by Natalia on 15.08.2024.
//

import Foundation

protocol LoginWebViewPresenterProtocol: AnyObject {
    func loadWebView()
    func fetchAccessToken(from url: URL)
}

final class LoginWebViewPresenter: LoginWebViewPresenterProtocol {
    
    weak var view: LoginWebViewProtocol?
    private let router: LoginRouterProtocol
    
    init(router: LoginRouterProtocol) {
        self.router = router
    }
    
    func loadWebView() {
        guard let authUrl = AuthService.shared.configureAuthUrl() else { return }
        view?.loadWebView(authUrl)
    }
    
    func fetchAccessToken(from url: URL) {
        AuthService.shared.fetchCode(from: url)
        router.showGallery()
    }
}

