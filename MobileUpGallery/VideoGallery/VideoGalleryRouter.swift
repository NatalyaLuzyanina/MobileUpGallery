//
//  VideoGalleryRouter.swift
//  MobileUpGallery
//
//  Created by Natalia on 18.08.2024.
//

import Foundation

protocol VideoGalleryRouterProtocol {
    func showVideoScreen(id: Int)
}

final class VideoGalleryRouter: Router, VideoGalleryRouterProtocol {
    
    func showVideoScreen(id: Int) {
        let vc = Builder.createVideo(id: id)
        pushScreen(vc)
    }
}
