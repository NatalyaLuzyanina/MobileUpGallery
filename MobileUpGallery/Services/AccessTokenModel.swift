//
//  AccessTokenModel.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

struct AccessTokenModel: Codable {
    let refreshToken: String
    let accessToken: String
    let expiringDate: Date
}
