//
//  PhotoGalleryModel.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

struct PhotoGalleryModel {
    let photos: [PhotoModel]
}

struct PhotoModel {
    let id: Int
    let url: String
}
