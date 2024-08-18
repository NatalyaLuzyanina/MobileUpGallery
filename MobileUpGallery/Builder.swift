//
//  Builder.swift
//  MobileUpGallery
//
//  Created by Natalia on 13.08.2024.
//

import UIKit

final class Builder {
    
    static func createLogin() -> UIViewController {
        let router = LoginRouter()
        let presenter = LoginPresenter(router: router)
        let view = LoginViewController(presenter: presenter)
        router.controller = view
        return view
    }
    
    static func createGallery() -> UIViewController {
        let router = GalleryContainerRouter()
        let presenter = GalleryContainerPresenter(router: router)
        let view = GalleryContainerViewController(presenter: presenter)
        router.controller = view
        return UINavigationController(rootViewController: view)  
    }
    
    static func createPhotoGallery() -> UIViewController {
        let router = PhotoGalleryRouter()
        let presenter = PhotoGalleryPresenter(router: router)
        let view = PhotoGalleryViewController(presenter: presenter)
        router.controller = view
        presenter.view = view
        return view
    }
    
    static func sreateVideoGallery() -> UIViewController {
        let router = VideoGalleryRouter()
        let presenter = VideoGalleryPresenter(router: router)
        let view = VideoGalleryViewController(presenter: presenter)
        router.controller = view
        presenter.view = view
        return view
    }
    
    static func createPhoto(id: Int) -> UIViewController {
        let presenter = PhotoPresenter(id: id)
        let view = PhotoViewController(presenter: presenter)
        return view
    }
    
    static func createVideo(id: Int) -> UIViewController {
        let presenter = VideoPresenter(id: id)
        let view = VideoViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
