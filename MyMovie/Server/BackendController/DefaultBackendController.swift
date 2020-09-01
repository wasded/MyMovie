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
            queryParameters["api_key"] = APIHelper.apiKey
        }
        
        let additionalHeaders = self.generateHeader()
        
        return self.networkWorker.performDataTaskWithMapping(with: method, to: APIHelper.baseURL, resource: resource, response: type, queryParameters: queryParameters, bodyParameters: bodyParameters, additionalHeaders: additionalHeaders, rawData: encodedData, bodyType: bodyType)
        .eraseToAnyPublisher()
    }
    
    func performRequest<T: Decodable>(with method: RequestMethod, to resource: String, response type: T.Type, queryParameters: [String: Any]? = nil, bodyParameters: [String: Any]? = nil, rawData: Data? = nil,  bodyType: BodyType, needApiToken: Bool = true) -> AnyPublisher<T, Error> {
        var queryParameters = queryParameters ?? [String: Any]()
        
        if needApiToken {
            queryParameters["api_key"] = APIHelper.apiKey
        }
        
        let additionalHeaders = self.generateHeader()
        
        return self.networkWorker.performDataTaskWithMapping(with: method, to: APIHelper.baseURL, resource: resource, response: type, queryParameters: queryParameters, bodyParameters: bodyParameters, additionalHeaders: additionalHeaders, rawData: rawData, bodyType: bodyType)
            
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
    func getMovies(language: String?, region: String?, sortBy: String?, certificationCountry: String?, certification: String?, certificationLte: String?, certificationGte: String?, includeAdult: Bool?, includeVideo: Bool?, page: Int?, primaryReleaseYear: Int?, primaryReleaseDateLte: String?, primaryReleaseDateGte: String?, releaseDateLte: String?, releaseDateGte: String?, withReleaseType: Int?, year: Int?, voteCountLte: Int?, voteCountGte: Int?, voteAverageLte: Double?, voteAverageGte: Double?, withCast: String?, withCrew: String?, withPeople: String?, withCompanies: String?, withGenres: String?, withoutGenres: String?, withKeywords: String?, withoutKeywords: String?, withRuntimeLte: Int?, withRuntimeGte: Int?, withOriginalLanguage: String?) -> AnyPublisher<PagingModel<MovieDiscoverResponse>, Error> {
        
        let model = MovieDiscoverRequest(language: language, region: region, sortBy: MovieSortingType(rawValue: sortBy ?? ""), certificationCountry: certificationCountry, certification: certification, certificationLte: certificationLte, certificationGte: certificationGte, includeAdult: includeAdult, includeVideo: includeVideo, page: page, primaryReleaseYear: primaryReleaseYear, primaryReleaseDateLte: primaryReleaseDateLte, primaryReleaseDateGte: primaryReleaseDateGte, releaseDateLte: releaseDateLte, releaseDateGte: releaseDateGte, withReleaseType: withReleaseType, year: year, voteCountLte: voteCountLte, voteCountGte: voteCountGte, voteAverageLte: voteAverageLte, voteAverageGte: voteAverageGte, withCast: withCast, withCrew: withCrew, withPeople: withPeople, withCompanies: withCompanies, withGenres: withGenres, withoutGenres: withoutGenres, withKeywords: withKeywords, withoutKeywords: withoutKeywords, withRuntimeLte: withRuntimeLte, withRuntimeGte: withRuntimeGte, withOriginalLanguage: withOriginalLanguage)
        
        return self.getMovies(model: model)
    }
    
    func getMovies(model: MovieDiscoverRequest) -> AnyPublisher<PagingModel<MovieDiscoverResponse>, Error> {
        return self.performRequest(with: .get, to: "/discover/movie", response: PagingModel<MovieDiscoverResponse>.self, queryParameters: model.dictionary, bodyType: .rawData)
    }
}

// MARK: - BackendMoviesController
extension DefaultBackendController: BackendMoviesController {
    func getDetail(movieID: Int, language: String, appendToResponse: String?) -> AnyPublisher<MovieDetailResponse, Error> {
        var queryParameters = [String: Any]()
        queryParameters["language"] = language
        queryParameters["append_to_response"] = appendToResponse
        
        return self.performRequest(with: .get, to: "/movie/\(movieID)", response: MovieDetailResponse.self, queryParameters: queryParameters, bodyType: .rawData)
    }
}
