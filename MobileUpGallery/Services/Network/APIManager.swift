//
//  APIManager.swift
//  MobileUpGallery
//
//  Created by Natalia on 18.08.2024.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    let vkAppId = "52161255"
    var redirectUri: String {
        "vk\(vkAppId)://vk.com/blank.html"
    }
    var callbackURLScheme: String {
        "vk\(vkAppId)"
    }
    
    let state = "abracadabra"
    let responseTypeCode = "code"
    let codeChallenge = "1DDoDWTzErI69s0x6NXeoLmrsf8FSTXbxQTD_gAryhk"
    let codeChallengeMethod = "sha256"
    let prompt = "login"
    let grantType = "authorization_code"
    let codeVerifier = "egPK3gB2Gtfh_sR7pReSKzHzIsansss5JFeJEOmFKBY"
    let ownerId = "-128666765"
    let scope = "photos video"
    
    private let scheme = "https"
    
    enum Request {
        case startAuth
        case accessToken
        case logout
        case getPhoto
        case getVideo
        
        var path: String {
            switch self {
            case .startAuth:
                "/authorize"
            case .logout:
                "/oauth2/logout"
            case .getPhoto:
                "/method/photos.getAll"
            case .getVideo:
                "/method/video.get"
            case .accessToken:
                "/oauth2/auth"
            }
        }
        
        var host: String {
            switch self {
            case .startAuth, .accessToken, .logout:
                "id.vk.com"
            case .getPhoto, .getVideo:
                "api.vk.com"
            }
        }
    }
    
    enum QueryItem: String {
        case state
        case responseType = "response_type"
        case codeChallenge = "code_challenge"
        case codeChallengeMethod = "code_challenge_method"
        case clientId = "client_id"
        case redirectUri = "redirect_uri"
        case prompt
        case grantType = "grant_type"
        case deviceId = "device_id"
        case codeVerifier = "code_verifier"
        case ownerId = "owner_id"
        case scope
    }
    
    func createUrl(for request: Request, queryItems: [QueryItem: String]? = nil) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = request.host
        
        var items: [URLQueryItem] = queryItems?.compactMap { item in
                .init(name: item.key.rawValue, value: item.value)
        } ?? []
        if request == .getPhoto || request == .getVideo {
            items.append(.init(name: "v", value: "5.199"))
        }
        urlComponents.queryItems = items
        urlComponents.path = request.path
        return urlComponents.url
    }
    
}
