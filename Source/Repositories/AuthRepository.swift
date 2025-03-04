//
//  AuthRepository.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 31.10.2024.
//

import Alamofire
import AuthenticationServices
import Foundation

enum AuthRepositoryError: Error {
    case unknown
    case authorizationRequired
}

final class AuthRepository: NSObject, NetworkRepository {
    private enum Constants {
        static let baseUrl = "https://id.vk.com"
        static let authEndpoint = "/oauth2/auth"
        static let authorizeEndpoint = "/authorize"
        static let logoutEndpoint = "/oauth2/logout"
        static let vkPrefix = "vk"
        static let redirectUri = "://vk.com/blank.html"
    }

    typealias NetworkRepositoryError = AuthRepositoryError

    let unknownError = AuthRepositoryError.unknown
    let authorizationRequiredError = AuthRepositoryError.authorizationRequired

    func startAuthSession(completion: @escaping (Result<Void, AuthRepositoryError>) -> Void) {
        var urlComponents = URLComponents(string: Environments.serverBaseUrl)
        urlComponents?.path = Constants.authorizeEndpoint
        let redirectUri = Constants.vkPrefix + Environments.vkAppId + Constants.redirectUri
        urlComponents?.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "code_challenge", value: Environments.codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "sha256"),
            URLQueryItem(name: "client_id", value: Environments.vkAppId),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "prompt", value: "login"),
            URLQueryItem(name: "scope", value: "photos video")
        ]

        let url = urlComponents?.url
        guard let url = url else {
            completion(.failure(.unknown))
            return
        }
        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: Constants.vkPrefix + Environments.vkAppId
        ) { [weak self] callbackUrl, _ in
            guard let url = callbackUrl else {
                completion(.failure(.unknown))
                return
            }
            let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
            let code = queryItems?.first(where: { $0.name == "code" })?.value
            let deviceId = queryItems?.first(where: { $0.name == "device_id" })?.value

            guard let code, let deviceId, self?.saveDeviceId(deviceId) == true else {
                completion(.failure(.unknown))
                return
            }
            self?.performAccessTokenRequest(with: code, deviceId: deviceId, completion: { result in
                completion(result)
            })
        }
        session.presentationContextProvider = self
        session.start()
    }

    private func performAccessTokenRequest(
        with code: String,
        deviceId: String,
        completion: @escaping (Result<Void, AuthRepositoryError>) -> Void
    ) {
        let bodyParameters = ["code": code]
        let redirectUri = Constants.vkPrefix + Environments.vkAppId + Constants.redirectUri
        let query = [
            ServerInteractableQueryItem(name: "client_id", value: Environments.vkAppId),
            ServerInteractableQueryItem(name: "grant_type", value: "authorization_code"),
            ServerInteractableQueryItem(name: "device_id", value: deviceId),
            ServerInteractableQueryItem(name: "redirect_uri", value: redirectUri),
            ServerInteractableQueryItem(name: "code_verifier", value: Environments.codeVerifier)
        ]
        let parameters = ServerInteractableRequestParameters(
            method: .post,
            query: query,
            bodyParameters: bodyParameters
        )
        makeRequest(
            type: UserTokenModel.self,
            url: Constants.baseUrl,
            endpoint: Constants.authEndpoint,
            parameters: parameters,
            isAuthRequired: false,
            errorMapper: nil
        ) { [weak self] in
            guard case let .success(token) = $0, self?.saveToken(token) == true else {
                guard case .failure(let error) = $0 else {
                    return completion(.failure(.unknown))
                }
                return completion(.failure(error))
            }
            completion(.success(()))
        }
    }

    func logout(completion: @escaping (Result<Void, AuthRepositoryError>) -> Void) {
        guard let accessToken = getToken()?.accessToken else {
            completion(.failure(authorizationRequiredError))
            return
        }

        let bodyParameters = [
            "client_id": Environments.vkAppId,
            "access_token": accessToken
        ]

        let parameters = ServerInteractableRequestParameters(
            method: .post,
            bodyParameters: bodyParameters
        )

        makeRequest(
            url: Constants.baseUrl,
            endpoint: Constants.logoutEndpoint,
            parameters: parameters,
            isAuthRequired: true,
            errorMapper: nil,
            completion: completion
        )
    }
}

extension AuthRepository: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let windowDelegate = windowScene.delegate as? SceneDelegate,
           let window = windowDelegate.window {
            return window
        }
        return ASPresentationAnchor()
    }
}
