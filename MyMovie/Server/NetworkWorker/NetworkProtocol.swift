//
//  NetworkProtocol.swift
//  Coolpon.client
//
//  Created by Andrey Baskirtcev on 19.06.2020.
//  Copyright © 2020 Coolpon. All rights reserved.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func performDataTaskWithMapping<T: Decodable>(with method: RequestMethod, to body: String, resource: String, response type: T.Type, queryParameters: [String: Any]?, bodyParameters: [String: Any]?, additionalHeaders: [String: String]?, rawData: Data?, bodyType: BodyType) -> AnyPublisher<T, Error>
    func performDataTask<T:Decodable>(with method: RequestMethod, to body: String, resource: String, queryParameters: [String: Any]?, bodyParameters: [String: Any]?, additionalHeaders: [String: String]?, rawData: Data?, bodyType: BodyType) -> AnyPublisher<T, Error>
    func encode<R: Encodable>(model : R) -> (Data?, Error?)
    
    var supportedErrorTypes:[CodableNetworkError.Type] {get set}
}
