//
//  AuthModel.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

struct AccessTokenResponse: Decodable {
    let refreshToken: String
    let accessToken: String
    let idToken: String
    let tokenType: String
    let expiresIn: Int
    let userId: Int
    let state: String
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case accessToken = "access_token"
        case idToken = "id_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case userId = "user_id"
        case state
        case scope
    }
}
