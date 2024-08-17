//
//  GalleryContainerRouter.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

protocol GalleryContainerRouterProtocol {
    func showLogin()
}

final class GalleryContainerRouter: Router, GalleryContainerRouterProtocol {
    
    func showLogin() {
        let vc = Builder.createLogin()
        presentScreen(vc)
    }
}
