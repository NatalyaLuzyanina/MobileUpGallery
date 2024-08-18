//
//  GalleryContainerPresenter.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

protocol GalleryContainerPresenterProtocol {
    func logout()
}

final class GalleryContainerPresenter: GalleryContainerPresenterProtocol {
    
    weak var view: GalleryContainerViewProtocol?
    private let router: GalleryContainerRouterProtocol
    
    init(router: GalleryContainerRouterProtocol) {
        self.router = router
    }
    
    func logout() {
        AuthService.shared.logout { [weak self] result in
            switch result {
            case .success():
                self?.router.showLogin()
            case .failure(let error):
                self?.view?.showError(error)
            }
        }
    }
    
}
