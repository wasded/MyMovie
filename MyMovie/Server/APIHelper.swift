//
//  APIConstants.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

public enum HTTPError: LocalizedError, Error, Identifiable {
    public var id: String { localizedDescription }
    case urlError(URLError)
    case responseError((Int,String))
    case decodingError(DecodingError)
    case genericError
    case invalidRequest
    case encodeFailed
}

// FIXME: Должна быть зависимостью

public struct APIHelper {
    enum PosterType {
        case original
        case custom(Int)
        
        func getURLParameter() -> String {
            switch self {
            case .original:
                return "original"
            case .custom(let width):
                return "w\(width)"
            }
        }
    }
    
    public static let codeTimeout = 40
    public static let baseURL = "https://api.themoviedb.org/3"
    public static let imageBaseURL = "http://image.tmdb.org/t/p/"
    public static let apiKey = "ee044de647ad25b4f147aa2142bd2693"
    
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    static func getImageURL(posterType: APIHelper.PosterType, posterPath: String) -> URL? {
        return URL(string: String(format: "%@/%@/%@", APIHelper.imageBaseURL, posterType.getURLParameter(), posterPath))
    }
}
    
