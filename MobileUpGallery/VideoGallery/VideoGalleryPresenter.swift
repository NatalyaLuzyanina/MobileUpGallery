//
//  VideoGalleryPresenter.swift
//  MobileUpGallery
//
//  Created by Natalia on 18.08.2024.
//

import Foundation

protocol VideoGalleryPresenterProtocol {
    func showVideo(with id: Int)
}

final class VideoGalleryPresenter: VideoGalleryPresenterProtocol {
    
    weak var view: VideoGalleryViewControllerProtocol?
    private let router: VideoGalleryRouterProtocol
    
    init(router: VideoGalleryRouterProtocol) {
        self.router = router
    }
    
    func showVideo(with id: Int) {
        router.showVideoScreen(id: id)
    }
}
