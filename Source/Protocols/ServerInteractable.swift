//
//  ServerInteractable.swift
//  MobileUpGallery
//
//  Created by Natalia Luzyanina on 31.10.2024.
//

import Foundation

enum ServerInteractableHttpMethod {
    case get
    case post
}

struct ServerInteractableHeader {
    let name: String
    let value: String
}

typealias ServerInteractableBodyParameters = [String: String]

struct ServerInteractableQueryItem {
    let name: String
    let value: String?

    init(name: String, value: String? = nil) {
        self.name = name
        self.value = value
    }
}

protocol ServerInteractable {
    associatedtype ServerInteractableError: Error

    static var shared: Self { get }

    func request<SuccessValue: Decodable>(
        type: SuccessValue.Type,
        url: String,
        endpoint: String,
        parameters: ServerInteractableRequestParameters,
        completion: @escaping (Result<SuccessValue, ServerInteractableError>) -> Void
    )

    func request(
        url: String,
        endpoint: String,
        parameters: ServerInteractableRequestParameters,
        completion: @escaping (Result<Void, ServerInteractableError>) -> Void
    )
}

struct ServerInteractableRequestParameters {
    let method: ServerInteractableHttpMethod
    var headers: [ServerInteractableHeader]
    let query: [ServerInteractableQueryItem]
    let bodyParameters: ServerInteractableBodyParameters?

    init(
        method: ServerInteractableHttpMethod,
        headers: [ServerInteractableHeader] = [],
        query: [ServerInteractableQueryItem] = [],
        bodyParameters: ServerInteractableBodyParameters? = nil
    ) {
        self.method = method
        self.headers = headers
        self.query = query
        self.bodyParameters = bodyParameters
    }
}
