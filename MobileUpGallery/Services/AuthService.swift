//
//  AuthService.swift
//  MobileUpGallery
//
//  Created by Natalia on 15.08.2024.
//

import Alamofire
import AuthenticationServices

final class AuthService {
    
    static let shared = AuthService()
    private init(){}
    
    func configureAuthUrl() -> URL? {
        var urlComponets = URLComponents()
        urlComponets.scheme = "https"
        urlComponets.host = "oauth.vk.com"
        urlComponets.path = "/authorize"
        
        urlComponets.queryItems = [
            URLQueryItem(name: "client_id", value: "52141203"),
            URLQueryItem(name: "redirect_uri", value: "vk52141203://vk.com/blank.html"),
            URLQueryItem(name: "state", value: "abracadabra"),
            URLQueryItem(name: "prompt", value: "login"),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "code_challenge", value: "1DDoDWTzErI69s0x6NXeoLmrsf8FSTXbxQTD_gAryhk"),
            URLQueryItem(name: "code_challenge_method", value: "sha256")
        ]
        
        let url = urlComponets.url
        return url
    }
    
    func fetchCode(from url: URL) {
        print("redirect url - \(url)")
        let params = url.fragment?.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { partialResult, param in
                var dict = partialResult
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        if let code = params?["code"] {
            fetchAccessToken(with: code)
        }
    }
    
    func fetchAccessToken(with code: String) {
        var urlComponets = URLComponents()
        urlComponets.scheme = "https"
        urlComponets.host = "id.vk.com"
        urlComponets.path = "/oauth2/auth"
        urlComponets.queryItems = [
            URLQueryItem(name: "client_id", value: "52141203"),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "redirect_uri", value: "vk52141203://vk.com/blank.html"),
            URLQueryItem(name: "code_verifier", value: "egPK3gB2Gtfh_sR7pReSKzHzIsansss5JFeJEOmFKBY"),
        ]
        
        guard let url = urlComponets.url else {
            print("url does not exist")
            return
        }
        
        let parameters = ["code": code]
        
        let headers = HTTPHeaders(["Content-Type": "application/json"])
        
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            headers: headers
        )
        .validate()
        .responseDecodable(of: [String: String].self) { response in
            switch response.result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
            }
        }
        
    }
}
