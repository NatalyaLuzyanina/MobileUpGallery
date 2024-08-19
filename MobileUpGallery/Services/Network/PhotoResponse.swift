//
//  PhotoResponse.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

struct PhotoResponse: Codable {
    let response: Response
}

struct Response: Codable {
    let count: Int
    let items: [PhotoItem]
}

struct PhotoItem: Codable {
    let id: Int
    let albumId: Int
    let ownerId: Int
    let userId: Int
    let text: String
    let dateInt: Int
    let sizes: [PhotoSize]

    enum CodingKeys: String, CodingKey {
        case id
        case albumId = "album_id"
        case ownerId = "owner_id"
        case userId = "user_id"
        case text
        case dateInt = "date"
        case sizes
    }
    
    var mediumSize: PhotoSize? {
        sizes.first(where: { $0.type == "m" } )
    }
    
    var largeSize: PhotoSize? {
        sizes.first(where: { $0.type == "x" } )
    }
    
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(dateInt))
    }
    
}

struct PhotoSize: Codable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}
