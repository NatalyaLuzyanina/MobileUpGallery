//
//  VideoPresenter.swift
//  MobileUpGallery
//
//  Created by Natalia on 18.08.2024.
//

import Foundation


protocol VideoPresenterProtocol {
    func loadData()
}

final class VideoPresenter: VideoPresenterProtocol {
    
    weak var view: VideoViewControllerProtocol?
    private let storage = UserDefaultsStorage.shared
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func loadData() {
        guard
            let videoItems: VideoResponse = storage.get(.videoResponse),
            let video = videoItems.response.items
                .first(where: { $0.id == id }) 
        else { return }
        
        let model = DetailVideoModel(
            title: video.title,
            url: video.player
        )
        view?.updateView(with: model)
    }
}
