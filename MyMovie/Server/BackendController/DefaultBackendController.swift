//
//  DefaultBackendController.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Resolver
import Combine

class DefaultBackendController {
    // MARK: - Properties
    @Injected var networkWorker: NetworkWorker
    @Injected var credentialStorage: CredentialStorage
    
    // MARK: - Init
    init(networkWorker: NetworkWorker, credentialStorage: CredentialStorage) {
        self.networkWorker = networkWorker
    }
    
    // MARK: - Methods
    func performRequestWithModel<T: Decodable, R: Encodable>(with method: RequestMethod, to resource: String, response type: T.Type, queryParameters: [String: Any]? = nil, bodyParameters: [String: Any]? = nil, rawData: Data? = nil, model: R?, bodyType: BodyType, needApiToken: Bool = true) -> AnyPublisher<T, Error> {
        var queryParameters = queryParameters ?? [String: Any]()
        
        var encodedData: Data?
        if model != nil {
            let result = self.networkWorker.encode(model: model)
            if let data = result.0 {
                encodedData = data
            } else if let _ = result.1 {
                return Result<T, Error>.Publisher(HTTPError.encodeFailed).eraseToAnyPublisher()
            }
        } else if rawData != nil{
            encodedData = rawData
        }
        
        if needApiToken {
            queryParameters["api_key"] = APIConstants.apiKey
        }
        
        let additionalHeaders = self.generateHeader()
        
        return self.networkWorker.performDataTaskWithMapping(with: method, to: APIConstants.baseURL, resource: resource, response: type, queryParameters: queryParameters, bodyParameters: bodyParameters, additionalHeaders: additionalHeaders, rawData: encodedData, bodyType: bodyType)
        .eraseToAnyPublisher()
    }
    
    func performRequest<T: Decodable>(with method: RequestMethod, to resource: String, response type: T.Type, queryParameters: [String: Any]? = nil, bodyParameters: [String: Any]? = nil, rawData: Data? = nil,  bodyType: BodyType, needApiToken: Bool = true) -> AnyPublisher<T, Error> {
        var queryParameters = queryParameters ?? [String: Any]()
        
        if needApiToken {
            queryParameters["api_key"] = APIConstants.apiKey
        }
        
        let additionalHeaders = self.generateHeader()
        
        return self.networkWorker.performDataTaskWithMapping(with: method, to: APIConstants.baseURL, resource: resource, response: type, queryParameters: queryParameters, bodyParameters: bodyParameters, additionalHeaders: additionalHeaders, rawData: rawData, bodyType: bodyType)
            
    }
    
    private func generateHeader() -> [String : String] {
        var header = [String : String]()
        
        return header
    }
}

// MARK: - BackendAuthorizationController
extension DefaultBackendController: BackendAuthorizationController {
    func createRequestToken() -> AnyPublisher<CreateRequestTokenResponse, Error> {
        return self.performRequest(with: .get, to: "/authentication/token/new", response: CreateRequestTokenResponse.self, queryParameters: ["api_key": APIConstants.apiKey], bodyType: .rawData)
    }
    
    func createSession(requestToken: String) -> AnyPublisher<CreateSessionResponse, Error> {
        return self.performRequest(with: .post, to: "/authentication/session/new", response: CreateSessionResponse.self, queryParameters: ["request_token": requestToken], bodyType: .rawData)
    }
    
    func deleteSession(sessionID: String) -> AnyPublisher<DeleteSessionResponse, Error> {
        return self.performRequest(with: .delete, to: "/authentication/session", response: DeleteSessionResponse.self, queryParameters: ["session_id": sessionID], bodyType: .rawData)
    }
}
