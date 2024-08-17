//
//  AuthService.swift
//  MobileUpGallery
//
//  Created by Natalia on 15.08.2024.
//

import Alamofire
import AuthenticationServices
import KeychainSwift

final class AuthService: NSObject {
    
    static let shared = AuthService()
    private override init(){
        super.init()
    }
    
    private let keychain = KeychainSwift()
    
    func startAuthSession(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        
        let queryItems: [URLQueryItem] = [
            .init(name: "state", value: "abracadabra"),
            .init(name: "response_type", value: "code"),
            .init(name: "code_challenge", value: "1DDoDWTzErI69s0x6NXeoLmrsf8FSTXbxQTD_gAryhk"),
            .init(name: "code_challenge_method", value: "sha256"),
            .init(name: "client_id", value: "52141203"),
            .init(name: "redirect_uri", value: "vk52141203://vk.com/blank.html"),
            .init(name: "prompt", value: "login")
        ]
        
        guard let url = createUrl(path: "/authorize", queryItems: queryItems) else {
            completion(.failure(.authError))
            return
        }
        
        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: "vk52141203"
        ) { [weak self] callbackUrl, _ in
            guard let url = callbackUrl else {
                completion(.failure(.authError))
                return
            }
            
            let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
            let code = queryItems?.first(where: { $0.name == "code" })?.value
            let deviceId = queryItems?.first(where: { $0.name == "device_id" })?.value
            self?.fetchAccessToken(with: code, deviceId: deviceId, completion: { result in
                completion(result)
            })
            
        }
        session.presentationContextProvider = self
        session.start()
    }
    
    private func fetchAccessToken(with code: String?, deviceId: String?, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard let code = code, let deviceId = deviceId else {
            completion(.failure(.authError))
            return
        }
        
        let queryItems: [URLQueryItem] = [
            .init(name: "client_id", value: "52141203"),
            .init(name: "grant_type", value: "authorization_code"),
            .init(name: "device_id", value: deviceId),
            .init(name: "redirect_uri", value: "vk52141203://vk.com/blank.html"),
            .init(name: "code_verifier", value: "egPK3gB2Gtfh_sR7pReSKzHzIsansss5JFeJEOmFKBY"),
        ]
        
        guard let url = createUrl(path: "/oauth2/auth", queryItems: queryItems) else {
            completion(.failure(.authError))
            return
        }
        
        let parameters = ["code": code]
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
        .validate()
        .responseDecodable(of: AccessTokenResponse.self) { [weak self] response in
            switch response.result {
            case .success(let response):
                self?.keychain.set(response.accessToken, forKey: "accessToken")
                self?.keychain.set(response.refreshToken, forKey: "refreshToken")
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.responseError))
                print("Request error: \(error.localizedDescription)")
            }
        }
    }
    
    private func createUrl(path: String, queryItems: [URLQueryItem]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "id.vk.com"
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}

extension AuthService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let windowDelegate = windowScene.delegate as? SceneDelegate,
           let window = windowDelegate.window {
            return window
        }
        return ASPresentationAnchor()
    }
}
