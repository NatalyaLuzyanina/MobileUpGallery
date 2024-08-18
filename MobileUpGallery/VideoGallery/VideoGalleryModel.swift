//
//  VideoGalleryModel.swift
//  MobileUpGallery
//
//  Created by Natalia on 18.08.2024.
//

import Foundation

struct VideoGalleryModel {
    let videos: [VideoModel]
}

struct VideoModel {
    let id: Int
    let url: String
}
