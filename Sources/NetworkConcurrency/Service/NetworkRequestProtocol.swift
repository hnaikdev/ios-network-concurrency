//
//  NetworkRequestProtocol.swift
//  NetworkConcurrency
//
//  Created by Hiral Naik on 1/30/26.
//

import Foundation

public protocol NetworkRequestProtocol {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: String]? { get }
    var body: Data? { get }
    var cachePolicy: CachePolicy { get }
}

public extension NetworkRequestProtocol {
    var headers: [String: String]? {
        nil
    }
    
    var queryParameters: [String: String]? {
        nil
    }
    var body: Data? {
        nil
    }
    
    var cachePolicy: CachePolicy {
        .networkOnly
    }
}

extension NetworkRequestProtocol {
    func urlRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        if let queryParameters {
            components.queryItems = queryParameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        
        headers?.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
}
