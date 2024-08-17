//
//  PhotoGalleryRouter.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

protocol PhotoGalleryRouterProtocol {
    func showPhoto(id: Int)
}

final class PhotoGalleryRouter: Router, PhotoGalleryRouterProtocol {
    func showPhoto(id: Int) {
        let vc = Builder.createPhoto(id: id)
        pushScreen(vc)
    }
}
