//
//  VideoResponse.swift
//  MobileUpGallery
//
//  Created by Natalia on 18.08.2024.
//

import Foundation

struct VideoResponse: Codable {
    let response: VideoResponseData
}

struct VideoResponseData: Codable {
    let count: Int
    let items: [VideoItem]
}

struct VideoItem: Codable {
    let date: Int
    let description: String
    let duration: Int
    let image: [VideoImage]
    let width: Int
    let height: Int
    let id: Int
    let title: String
    let player: String
    let added: Int
    
    var highestResolutionImageURL: String? {
        image.max { $0.width < $1.width }?.url
    }
}

struct VideoImage: Codable {
    let url: String
    let width: Int
    let height: Int
}
