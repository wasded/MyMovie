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
    @Injected var networkWorker: NetworkWorker
    
    init(networkWorker: NetworkWorker) {
        self.networkWorker = networkWorker
    }
    
    public func performRequestWithModel<T: Decodable, R: Encodable>(with method: RequestMethod, to resource: String, response type: T.Type, queryParameters: [String: Any]? = nil, bodyParameters: [String: Any]? = nil, rawData: Data? = nil, model: R?, bodyType: BodyType) -> AnyPublisher<T, Error> {

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
        
        let additionalHeaders = self.generateHeader()
        
        return self.networkWorker.performDataTaskWithMapping(with: method, to: APIConstants.baseURL, resource: resource, response: type, queryParameters: queryParameters, bodyParameters: bodyParameters, additionalHeaders: additionalHeaders, rawData: encodedData, bodyType: bodyType)
        .eraseToAnyPublisher()
    }
    
    public func performRequest<T: Decodable>(with method: RequestMethod, to resource: String, response type: T.Type, queryParameters: [String: Any]? = nil, bodyParameters: [String: Any]? = nil, rawData: Data? = nil,  bodyType: BodyType) -> AnyPublisher<T, Error> {
        
        let additionalHeaders = self.generateHeader()
        
        return self.networkWorker.performDataTaskWithMapping(with: method, to: APIConstants.baseURL, resource: resource, response: type, queryParameters: queryParameters, bodyParameters: bodyParameters, additionalHeaders: additionalHeaders, rawData: rawData, bodyType: bodyType)
            
    }
    
    private func generateHeader() -> [String : String] {
        var header = [String : String]()
    
//        if let token = self.credentialStorage.token {
//            header["Authorization"] = "Bearer \(token)"
//        }
        
        return header
    }
}

extension DefaultBackendController: BackendAuthorizationController {
    func createRequestToken() -> AnyPublisher<CreateRequestTokenResponse, Error> {
        return self.performRequest(with: .get, to: "/authentication/token/new", response: CreateRequestTokenResponse.self, queryParameters: ["api_key": APIConstants.apiKey], bodyType: .rawData)
    }
    
    func createSession(username: String, password: String, requestToken: String) -> AnyPublisher<CreateSessionResponse, Error> {
        let queryParameters = ["username": username,
                               "password": password,
                               "request_token": requestToken]
        return self.performRequest(with: .get, to: "/authentication/token/new", response: CreateSessionResponse.self, queryParameters: queryParameters, bodyType: .rawData)
    }
}
