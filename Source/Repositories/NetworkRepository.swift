//
//  NetworkRepository.swift
//  MobileUpGallery
//
//  Created by Natalia Luzyanina on 31.10.2024.
//

import Foundation
import Alamofire

protocol NetworkRepository: AnyObject {
    associatedtype NetworkRepositoryError: Error

    var unknownError: NetworkRepositoryError { get }
    var authorizationRequiredError: NetworkRepositoryError { get }
}

extension NetworkRepository {
    private var accessTokenKey: String { "com.mobileup.MobileUpGallery.accessToken" }
    private var refreshTokenKey: String { "com.mobileup.MobileUpGallery.refreshToken" }
    private var deviceIdKey: String { "com.mobileup.MobileUpGallery.deviceId" }

    var isUserAuthorized: Bool { getToken() != nil }

    func makeRequest(
        url: String,
        endpoint: String,
        parameters: ServerInteractableRequestParameters,
        isAuthRequired: Bool,
        isRetry: Bool = false,
        errorMapper: ((ServerClientService.ServerInteractableError) -> NetworkRepositoryError)?,
        completion: @escaping (Result<Void, NetworkRepositoryError>) -> Void
    ) {
        guard let preparedParameters = prepareParameters(parameters: parameters, isAuthRequired: isAuthRequired) else {
            return completion(.failure(authorizationRequiredError))
        }
        ServerClientService.shared.request(
            url: url,
            endpoint: endpoint,
            parameters: preparedParameters,
            completion: { [weak self] in
                self?.handleRequestResult(
                    $0,
                    isRetry: isRetry,
                    repeater: { [weak self] in
                        self?.makeRequest(
                            url: url,
                            endpoint: endpoint,
                            parameters: parameters,
                            isAuthRequired: isAuthRequired,
                            isRetry: isRetry,
                            errorMapper: errorMapper,
                            completion: completion
                        )
                    },
                    errorMapper: errorMapper,
                    completion: completion
                )
            }
        )
    }

    func makeRequest<SuccessValue: Decodable>(
        type: SuccessValue.Type,
        url: String,
        endpoint: String,
        parameters: ServerInteractableRequestParameters,
        isAuthRequired: Bool,
        isRetry: Bool = false,
        errorMapper: ((ServerClientService.ServerInteractableError) -> NetworkRepositoryError)?,
        completion: @escaping (Result<SuccessValue, NetworkRepositoryError>) -> Void
    ) {
        guard let preparedParameters = prepareParameters(parameters: parameters, isAuthRequired: isAuthRequired) else {
            return completion(.failure(authorizationRequiredError))
        }
        ServerClientService.shared.request(
            type: SuccessValue.self,
            url: url,
            endpoint: endpoint,
            parameters: preparedParameters,
            completion: { [weak self] in
                self?.handleRequestResult(
                    $0,
                    isRetry: isRetry,
                    repeater: { [weak self] in
                        self?.makeRequest(
                            type: type,
                            url: url,
                            endpoint: endpoint,
                            parameters: parameters,
                            isAuthRequired: isAuthRequired,
                            isRetry: isRetry,
                            errorMapper: errorMapper,
                            completion: completion
                        )
                    },
                    errorMapper: errorMapper,
                    completion: completion
                )
            }
        )
    }

    func saveDeviceId(_ deviceId: String) -> Bool {
        let deviceIdSaved = saveToKeychain(value: deviceId, key: deviceId)
        return deviceIdSaved
    }

    func getDeviceId() -> String? {
        let deviceId = getStringFromKechain(key: deviceIdKey)
        return deviceId
    }

    func saveToken(_ token: UserTokenModel) -> Bool {
        let accessTokenSaved = saveToKeychain(value: token.accessToken, key: accessTokenKey)
        let refreshTokenSaved = saveToKeychain(value: token.refreshToken, key: refreshTokenKey)

        return accessTokenSaved && refreshTokenSaved
    }

    func getToken() -> UserTokenModel? {
        guard
            let accessToken = getStringFromKechain(key: accessTokenKey),
            let refreshToken = getStringFromKechain(key: refreshTokenKey)
        else {
            return nil
        }

        return UserTokenModel(accessToken: accessToken, refreshToken: refreshToken)
    }

    private func prepareParameters(
        parameters: ServerInteractableRequestParameters,
        isAuthRequired: Bool
    ) -> ServerInteractableRequestParameters? {
        var parameters = parameters

        if isAuthRequired {
            guard let token = getToken() else {
                return nil
            }
            let authHeader = ServerInteractableHeader(name: "Authorization", value: "Bearer \(token.accessToken)")
            parameters.headers.append(authHeader)
        }
        parameters.headers.append(ServerInteractableHeader(name: "accept", value: "application/json"))
        parameters.headers.append(ServerInteractableHeader(name: "Content-Type", value: "application/json"))
        return parameters
    }

    private func saveToKeychain(value: String, key: String) -> Bool {
        let data = Data(value.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    private func getStringFromKechain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var data: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &data)
        guard status == errSecSuccess, let data = data as? Data else {
            return nil
        }
        let statusString = String(decoding: data, as: UTF8.self)

        return statusString
    }

    private func deleteTokenFromKeychain() {
        let accessTokenQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accessTokenKey
        ]
        let refreshTokenQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: refreshTokenKey
        ]

        SecItemDelete(accessTokenQuery as CFDictionary)
        SecItemDelete(refreshTokenQuery as CFDictionary)
    }

    private func handleRequestError(
        error: ServerClientService.ServerInteractableError,
        isRetry: Bool,
        repeater: @escaping () -> Void,
        errorMapper: ((ServerClientService.ServerInteractableError) -> NetworkRepositoryError)?,
        completion: @escaping (NetworkRepositoryError) -> Void
    ) {
        guard error.code.rawValue == 401 else {
            return completion(errorMapper?(error) ?? unknownError)
        }

        guard isRetry == false, let token = getToken() else {
            deleteTokenFromKeychain()
            return completion(authorizationRequiredError)
        }

        refreshAccessToken(refreshToken: token.refreshToken) { [weak self] in
            guard let self else {
                return
            }

            guard $0 == true else {
                deleteTokenFromKeychain()
                return completion(authorizationRequiredError)
            }

            repeater()
        }
    }

    private func handleRequestResult<SuccessValue: Decodable>(
        _ result: Result<SuccessValue, ServerClientService.ServerInteractableError>,
        isRetry: Bool,
        repeater: @escaping () -> Void,
        errorMapper: ((ServerClientService.ServerInteractableError) -> NetworkRepositoryError)?,
        completion: @escaping (Result<SuccessValue, NetworkRepositoryError>) -> Void
    ) {
        guard case .failure(let error) = result else {
            guard case .success(let successValue) = result else {
                return completion(.failure(unknownError))
            }

            return completion(.success(successValue))
        }

        handleRequestError(
            error: error,
            isRetry: isRetry,
            repeater: repeater,
            errorMapper: errorMapper,
            completion: { completion(.failure($0)) }
        )
    }

    private func handleRequestResult(
        _ result: Result<Void, ServerClientService.ServerInteractableError>,
        isRetry: Bool,
        repeater: @escaping () -> Void,
        errorMapper: ((ServerClientService.ServerInteractableError) -> NetworkRepositoryError)?,
        completion: @escaping (Result<Void, NetworkRepositoryError>) -> Void
    ) {
        guard case .failure(let error) = result else {
            guard case .success(let successValue) = result else {
                return completion(.failure(unknownError))
            }
            return completion(.success(successValue))
        }

        handleRequestError(
            error: error,
            isRetry: isRetry,
            repeater: repeater,
            errorMapper: errorMapper,
            completion: { completion(.failure($0)) }
        )
    }

    private func refreshAccessToken(refreshToken: String, completion: @escaping (Bool) -> Void) {
        guard let deviceId = getDeviceId() else {
            completion(false)
            return
        }
        let bodyParameters: ServerInteractableBodyParameters = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "device_id": deviceId
        ]
        let parameters = ServerInteractableRequestParameters(method: .post, bodyParameters: bodyParameters)

        makeRequest(
            type: UserTokenModel.self,
            url: "https://id.vk.com",
            endpoint: "/oauth2/auth",
            parameters: parameters,
            isAuthRequired: false,
            isRetry: false,
            errorMapper: nil
        ) { [weak self] in
            guard case .success(let token) = $0, self?.saveToken(token) == true else {
                return completion(false)
            }
            return completion(true)
        }
    }
}
