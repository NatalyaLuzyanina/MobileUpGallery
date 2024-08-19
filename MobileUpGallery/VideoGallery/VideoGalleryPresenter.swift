//
//  VideoGalleryPresenter.swift
//  MobileUpGallery
//
//  Created by Natalia on 18.08.2024.
//

import Foundation

protocol VideoGalleryPresenterProtocol {
    func loadData()
    func showVideo(with id: Int)
}

final class VideoGalleryPresenter: VideoGalleryPresenterProtocol {
    
    weak var view: VideoGalleryViewControllerProtocol?
    private let router: VideoGalleryRouterProtocol
    
    init(router: VideoGalleryRouterProtocol) {
        self.router = router
    }
    
    func loadData() {
        NetworkService.shared.loadVideos { [weak self] result in
            switch result {
            case .success(let videoResponse):
                DispatchQueue.main.async {
                    self?.updateView(with: videoResponse.response)
                }
            case .failure(let error):
//                if let mockData = NetworkService.shared.getMockVideos()?.response {
//                    self?.updateView(with: mockData)
//                }
                self?.view?.showError(error)
            }
        }
    }
    
    func updateView(with data: VideoResponseData) {
        let videos = data.items.map {
            VideoModel(
                id: $0.id,
                title: $0.title,
                url: $0.highestResolutionImageURL ?? ""
            )
        }
        let model = VideoGalleryModel(videos: videos)
        view?.updateView(with: model)
    }
    
    func showVideo(with id: Int) {
        router.showVideoScreen(id: id)
    }
}
