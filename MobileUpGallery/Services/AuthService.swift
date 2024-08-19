//
//  AuthService.swift
//  MobileUpGallery
//
//  Created by Natalia on 15.08.2024.
//

import Alamofire
import AuthenticationServices

final class AuthService: NSObject {
    
    static let shared = AuthService()
    private override init(){
        super.init()
    }
    
    private let api = APIManager.shared
    
    var isUserAuthorized: Bool {
        guard let tokenInfo = KeychainStorage.shared.getToken() else { return false }
        let isUserAuthorized = tokenInfo.expiringDate > Date()
        return isUserAuthorized
    }
    
    func startAuthSession(completion: @escaping (Result<Void, ErrorModel>) -> Void) {
 
        let url = api.createUrl(
            for: .startAuth,
            queryItems: [
                .state: api.state,
                .responseType: api.responseTypeCode,
                .codeChallenge: api.codeChallenge,
                .codeChallengeMethod: api.codeChallengeMethod,
                .clientId: api.vkAppId,
                .redirectUri: api.redirectUri,
                .prompt: api.prompt,
                .scope: api.scope
            ])
        
        guard let url = url else {
            completion(.failure(.authError))
            return
        }
        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: api.callbackURLScheme
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
    
    func logout(completion: @escaping (Result<Void, ErrorModel>) -> Void) {
      
        guard let url = api.createUrl(for: .logout) else {
            completion(.failure(.logoutError))
            return
        }
        
        let accessToken = KeychainStorage.shared.getToken()?.accessToken
        let parameters = [
            "client_id": api.vkAppId,
            "access_token": accessToken
        ]
        
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .response() { response in
            switch response.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.logoutError))
                print("Request error: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchAccessToken(
        with code: String?,
        deviceId: String?,
        completion: @escaping (Result<Void, ErrorModel>) -> Void
    ) {
        guard let code = code, let deviceId = deviceId else {
            completion(.failure(.authError))
            return
        }
       
        let url = api.createUrl(
            for: .accessToken,
            queryItems: [
                .clientId: api.vkAppId,
                .grantType: api.grantType,
                .deviceId: deviceId,
                .redirectUri: api.redirectUri,
                .codeVerifier: api.codeVerifier
            ]
        )
        
        guard let url = url else {
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
        .responseDecodable(of: AccessTokenResponse.self) { response in
            switch response.result {
            case .success(let response):
                KeychainStorage.shared.clear()
                KeychainStorage.shared.save(
                    token: .init(
                        refreshToken: response.refreshToken,
                        accessToken: response.accessToken,
                        expiringDate: Date().addingTimeInterval(TimeInterval(response.expiresIn))
                    ),
                    key: .accessToken
                )
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.authError))
                print("Request error: \(error.localizedDescription)")
            }
        }
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
