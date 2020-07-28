//
//  NetworkWorker+Error.swift
//  Coolpon.client
//
//  Created by Andrey Baskirtcev on 19.06.2020.
//  Copyright © 2020 Coolpon. All rights reserved.
//

import Foundation

protocol CodableNetworkError: Error {
    static func decode(decoder: JSONDecoder, data: Data) throws -> Self
}

extension CodableNetworkError where Self: Codable {
     static func decode(decoder: JSONDecoder, data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}
