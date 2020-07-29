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
        return self.performRequest(with: .get, to: "/authentication/token/new", response: CreateRequestTokenResponse.self, queryParameters: nil, bodyType: .rawData)
    }
    
    func createSession(requestToken: String) -> AnyPublisher<CreateSessionResponse, Error> {
        return self.performRequest(with: .post, to: "/authentication/session/new", response: CreateSessionResponse.self, queryParameters: ["request_token": requestToken], bodyType: .rawData)
    }
    
    func deleteSession(sessionID: String) -> AnyPublisher<DeleteSessionResponse, Error> {
        return self.performRequest(with: .delete, to: "/authentication/session", response: DeleteSessionResponse.self, queryParameters: ["session_id": sessionID], bodyType: .rawData)
    }
}

// MARK: - BackendDiscoverController
extension DefaultBackendController: BackendDiscoverController {
    func getMovies(language: String?, region: String?, sortBy: Int?, certificationCountry: String?, certification: String?, certificationLte: String?, certificationGte: String?, includeAdult: Bool?, includeVideo: Bool?, page: Int, primaryReleaseYear: Int?, primaryReleaseDateLte: String?, primaryReleaseDateGte: String?, releaseDateLte: String?, releaseDateGte: String?, withReleaseType: Int?, year: Int?, voteCountLte: Double?, voteCountGte: Double?, voteAverageLte: Double?, voteAverageGte: Double?, withCast: String?, withCrew: String?, withPeople: String?, withCompanies: String?, withGenres: String?, withoutGenres: String?, withKeywords: String?, withRuntimeLte: String?, withRuntimeGte: String?, withOriginalLanguage: String?) -> AnyPublisher<PagingModel<MovieDiscover>, Error> {
        let queryItems: [String: Any] = [
            "language" : language as Any,
            "region" : region as Any,
            "sort_by" : sortBy as Any,
            "certification_country" : certificationCountry as Any,
            "certification" : certification as Any,
            "certification.lte" : certificationLte as Any,
            "certification.gte" : certificationGte as Any,
            "include_adult" : includeAdult as Any,
            "include_video" : includeVideo as Any,
            "page" : page as Any,
            "primary_release_year" : primaryReleaseYear as Any,
            "primary_release_date.gte" : primaryReleaseDateGte as Any,
            "primary_release_date.lte" : primaryReleaseDateLte as Any,
            "release_date.gte" : releaseDateGte as Any,
            "release_date.lte" : releaseDateLte as Any,
            "with_release_type" : withReleaseType as Any,
            "year" : year as Any,
            "vote_count.gte" : voteCountGte as Any,
            "vote_count.lte" : voteCountLte as Any,
            "vote_average.gte" : voteCountGte as Any,
            "vote_average.lte" : voteCountLte as Any,
            "with_cast" : withCast as Any,
            "with_crew" : withCrew as Any,
            "with_people" : withPeople as Any,
            "with_companies" : withCompanies as Any,
            "with_genres" : withGenres as Any,
            "without_genres" : withGenres as Any,
            "with_keywords" : withKeywords as Any,
            "with_runtime.gte" : withRuntimeGte as Any,
            "with_runtime.lte" : withRuntimeLte as Any,
            "with_original_language" : withOriginalLanguage as Any,
        ]
        
        return self.performRequest(with: .get, to: "/discover/movie", response: PagingModel<MovieDiscover>.self, queryParameters: queryItems, bodyType: .rawData)
    }
    
}
