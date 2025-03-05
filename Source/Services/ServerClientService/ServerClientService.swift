//
//  ServerClientService.swift
//  MobileUpGallery
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

import Foundation
import Alamofire

final class ServerClientServiceLogger: EventMonitor {
    func requestDidResume(_ request: Request) {
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⚡️ Request Started: \(request)
        ⚡️ Body Data: \(body)
        """
        NSLog(message)
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: AFDataResponse<Value>) {
        NSLog("⚡️ Response Received: \(response.debugDescription)")
    }
}

final class ServerClientService: ServerInteractable {
    typealias ServerInteractableError = URLError

    static let shared = ServerClientService()

    private let session: Session

    init() {
        let logger = ServerClientServiceLogger()
        self.session = Session(configuration: .default, eventMonitors: [logger])
    }

    func request(
        url: String,
        endpoint: String,
        parameters: ServerInteractableRequestParameters,
        completion: @escaping (Result<Void, ServerInteractableError>) -> Void
    ) {
        guard let dataRequest = getDataRequest(url: url, endpoint: endpoint, parameters: parameters) else {
            return completion(.failure(ServerInteractableError(.unknown)))
        }
        dataRequest
            .validate()
            .response { [weak self] in
                guard let self else {
                    return
                }

                switch $0.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(getError(error)))
                }
            }
    }

    func request<ReturnValue: Decodable>(
        type: ReturnValue.Type,
        url: String,
        endpoint: String,
        parameters: ServerInteractableRequestParameters,
        completion: @escaping (Result<ReturnValue, ServerInteractableError>) -> Void
    ) {
        guard let dataRequest = getDataRequest(url: url, endpoint: endpoint, parameters: parameters) else {
            return completion(.failure(ServerInteractableError(.unknown)))
        }

        dataRequest
            .validate()
            .responseDecodable(of: ReturnValue.self) { [weak self] in
                guard let self else {
                    return
                }

                switch $0.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(getError(error)))
                }
            }
    }

    private func getDataRequest(
        url: String,
        endpoint: String,
        parameters: ServerInteractableRequestParameters
    ) -> DataRequest? {
        guard let url = URL(string: url) else {
            return nil
        }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.path = endpoint
        urlComponents?.queryItems = parameters.query.map { .init(name: $0.name, value: $0.value) }
        guard let url = urlComponents?.url else {
            return nil
        }

        let alamofireHttpMethod = getAlamofireHttpMethod(from: parameters.method)
        var alamofireHeaders: HTTPHeaders?
        alamofireHeaders = HTTPHeaders(parameters.headers.map { HTTPHeader(name: $0.name, value: $0.value) })

        let dataRequest = session.request(
            url,
            method: alamofireHttpMethod,
            parameters: parameters.bodyParameters,
            encoder: JSONParameterEncoder.default,
            headers: alamofireHeaders
        )
        return dataRequest
    }

    private func getAlamofireHttpMethod(from serverRequestMethod: ServerInteractableHttpMethod) -> HTTPMethod {
        var alamofireHttpMethod: HTTPMethod
        switch serverRequestMethod {
        case .get:
            alamofireHttpMethod = .get
        case .post:
            alamofireHttpMethod = .post
        }
        return alamofireHttpMethod
    }

    private func getError(_ error: AFError) -> ServerInteractableError {
        let errorCode: ServerInteractableError.Code
        if let errorRawCode = error.responseCode {
            errorCode = ServerInteractableError.Code(rawValue: errorRawCode)
        } else {
            errorCode = .unknown
        }
        return ServerInteractableError(errorCode)
    }
}
