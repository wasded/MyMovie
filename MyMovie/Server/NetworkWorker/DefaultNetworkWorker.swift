//
//  DefaultNetworkWorker.swift
//  Coolpon.client
//
//  Created by Andrey Baskirtcev on 18.06.2020.
//  Copyright © 2020 Coolpon. All rights reserved.
//

import Foundation
import Combine

// MARK: -
enum RequestMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    case patch  = "PATCH"
}

enum BodyType {
    case json
    case urlencoded
    case rawData
    case imageData
    case formData
}

enum InternalError: Error {
    case invalidUrl(String)
    case invalidQuery(String)
    case invalidResponseCode(Int, HTTPURLResponse)
    case emptyContext
    case emptyResponseData
}

enum ResponseError: Error, LocalizedError {
    case InvalidHttpUrlFormat
    case InvalidErrorWithStatusCode(Int)
    case WrongStatusCodeWithError(Int, Error)
    case CodableNetworkError(CodableNetworkError)
    case decodingError
    
    var errorDescription: String?  {
        switch self {
        case .InvalidHttpUrlFormat:
            return ""
        case .InvalidErrorWithStatusCode(let statusCode):
            return "invalid status code \(statusCode)"
        case .WrongStatusCodeWithError(_, _):
            return ""
        case .CodableNetworkError(let networkError):
            return networkError.localizedDescription
        case .decodingError :
            return "decoding error"
        }
    }
}


class DefaultNetworkWorker: NetworkWorker {
    // MARK: - Properties
    var supportedErrorTypes: [CodableNetworkError.Type] = []
        
    let jsonEncoder: JSONEncoder
    var headers: [String: String]
    
    private let session: URLSession
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
        self.jsonEncoder = JSONEncoder()
        self.headers = ["Accept": "application/json"]
    }
    
    // MARK: - Methods
    func performDataTaskWithMapping<T: Decodable>(with method: RequestMethod, to body: String, resource: String, response type: T.Type, queryParameters: [String: Any]?, bodyParameters: [String: Any]?, additionalHeaders: [String: String]?, rawData: Data?, bodyType: BodyType) -> AnyPublisher<T, Error> {
        
        return self.performDataTask(with: method, to: body, resource: resource, queryParameters: queryParameters, bodyParameters: bodyParameters, additionalHeaders: additionalHeaders, rawData: rawData, bodyType: bodyType)
    }
    
    func performDataTask<T:Decodable>(with method: RequestMethod, to body: String, resource: String, queryParameters: [String: Any]?, bodyParameters: [String: Any]?, additionalHeaders: [String: String]?, rawData: Data?, bodyType: BodyType) -> AnyPublisher<T, Error> {
        var request: URLRequest
        do {
            request = try self.createRequest(with: method, body: body, resource: resource, queryParameters: queryParameters, bodyParameters: bodyParameters, additionalHeaders: additionalHeaders, rawData: rawData, bodyType: bodyType)
        } catch {
            return Result<T, Error>.Publisher(HTTPError.invalidRequest).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { $0 }
            .flatMap { (data, response) -> AnyPublisher<Data, Error> in
                return self.convertResponseErrorToSupportedTypes(data: data, response: response)
        }
        .decode(type: T.self, decoder: APIConstants.jsonDecoder)
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    private func createRequest(with method: RequestMethod, body: String, resource: String, queryParameters: [String: Any]?, bodyParameters: [String: Any]?, additionalHeaders: [String: String]?, rawData: Data?, bodyType: BodyType) throws -> URLRequest {
        guard let url = URL(string: body + resource) else {
            throw InternalError.invalidUrl("Cant create URL from base: \(body) and resource: \(resource)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let queryParameters = queryParameters {
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                throw InternalError.invalidUrl("Cant create URL components from url: \(url)")
            }
            components.queryItems = queryParameters.compactMap({ (key, value) -> URLQueryItem in
                return URLQueryItem(name: key, value: "\(value)")
            })
            guard let newUrl = components.url else {
                throw InternalError.invalidQuery("Cant create URL with given query items: \(queryParameters)")
            }
            request.url = newUrl
        }
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            request.setValue(version, forHTTPHeaderField: "X-APP-VERSION")
        }
        
        if let bodyParameters = bodyParameters {
            switch bodyType {
            case .json:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            case .urlencoded:
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpBody = bodyParameters.map({ (key, value) -> String in
                    return "\(key)=\(value)"
                }).joined(separator: "&").data(using: String.Encoding.utf8)
            case .formData:
                let boundary: String = "Boundary-\(UUID().uuidString)"
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                request.httpBody = self.createFormDataBody(from: bodyParameters, boundary: boundary)
            default:
                break
            }
        } else if let rawData = rawData {
            switch bodyType {
            case .rawData:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = rawData
            default:
                break
            }
        } else if bodyType == .imageData {
            request.setValue("image/tiff", forHTTPHeaderField: "Content-Type")
        }
        
        for (key, header) in self.headers {
            request.setValue(header, forHTTPHeaderField: key)
        }
        
        if let additionalHeaders = additionalHeaders {
            for (key, header) in additionalHeaders {
                request.setValue(header, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
    func encode<R: Encodable>(model : R) -> (Data?, Error?) {
        do {
            let data = try self.jsonEncoder.encode(model)
            return (data, nil)
        }
        catch {
            return (nil, error)
        }
    }
    
    private func createFormDataBody(from bodyParameters: [String: Any], boundary: String) -> Data {
        let httpBody = NSMutableData()
        for (key, value) in bodyParameters {
            if let value = value as? String {
                var fieldString = "--\(boundary)\r\n"
                fieldString += "Content-Disposition: form-data; name=\"\(key)\"\r\n"
                fieldString += "\r\n"
                fieldString += "\(value)\r\n"
                httpBody.appendString(fieldString)
            } else if let value = value as? Data {
                httpBody.appendString("--\(boundary)\r\n")
                httpBody.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).png\"\r\n")
                httpBody.appendString("Content-Type: image/png\r\n\n")
                httpBody.append(value)
                httpBody.appendString("\r\n")
            }
        }
        httpBody.appendString("--\(boundary)--\r\n")
        return httpBody as Data
    }
    
    private func convertResponseErrorToSupportedTypes(data: Data, response: URLResponse) -> AnyPublisher<Data, Error> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return Fail(error: ResponseError.InvalidHttpUrlFormat).eraseToAnyPublisher()
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            
            for type in self.supportedErrorTypes {
                if let error = try? type.decode(decoder: APIConstants.jsonDecoder, data: data) {
                    let resultError = ResponseError.CodableNetworkError(error)
                    return Fail(error: resultError).eraseToAnyPublisher()
                }
            }
            
            let resultError = ResponseError.InvalidErrorWithStatusCode(httpResponse.statusCode)
            return Fail(error: resultError).eraseToAnyPublisher()
        }
        
        return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
