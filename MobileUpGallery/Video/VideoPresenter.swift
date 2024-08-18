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
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func loadData() {
        let model = DetailVideoModel(title: "", url: "")
        view?.updateView(with: model)
    }
    
   
}
