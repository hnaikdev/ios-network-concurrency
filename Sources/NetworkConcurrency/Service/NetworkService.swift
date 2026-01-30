//
//  NetworkService.swift
//  NetworkConcurrency
//
//  Created by Hiral Naik on 1/30/26.
//

import Foundation

public actor NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let cacheManager: ObjectCacheProtocol
    
    public init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        self.session = URLSession(configuration: config)
        self.decoder = JSONDecoder()
        self.cacheManager = ObjectCacheService()
    }
    
    public func request<T>(_ request: any NetworkRequestProtocol) async throws -> T where T : Decodable {
        let cacheKey = try generateCacheKey(for: request)
        
        switch request.cachePolicy {
        case .cacheOnly:
            return try await fetchFromCache(key: cacheKey)
        case .networkOnly:
            return try await fetchFromNetwork(request: request, cacheKey: cacheKey)
        case .cacheFirst:
            if let cached: T = try? await fetchFromCache(key: cacheKey) {
                return cached
            }
            return try await fetchFromNetwork(request: request, cacheKey: cacheKey)
        case .networkFirst:
            do {
                return try await fetchFromNetwork(request: request, cacheKey: cacheKey)
            } catch {
                if let cached: T = try? await fetchFromCache(key: cacheKey) {
                    return cached
                }
                
                throw error
            }
        }
    }
    
    private func generateCacheKey(for request: NetworkRequestProtocol) throws -> String {
        let urlRequest = try request.urlRequest()
        return urlRequest.url?.absoluteString ?? UUID().uuidString
    }
    
    private func fetchFromCache<T: Decodable>(key: String) async throws -> T {
        do {
            let data: ResponseObject = try await cacheManager.retrieve(key)
            return try decoder.decode(T.self, from: data.objectData)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    private func fetchFromNetwork<T: Decodable>(request: NetworkRequestProtocol, cacheKey: String) async throws -> T {
        let urlRequest = try request.urlRequest()
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoded = try decoder.decode(T.self, from: data)
            if request.cachePolicy != .networkOnly {
                let obj = ResponseObject.init(objectKey: cacheKey, objectData: data)
                try await cacheManager.store(obj)
            }
            
            return decoded
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    public func clearCache() async {
        await cacheManager.clear()
    }
}

fileprivate struct ResponseObject: Codable, ObjectCache {
    
    let objectKey: String
    let objectData: Data
    
    init(objectKey: String, objectData: Data) {
        self.objectKey = objectKey
        self.objectData = objectData
    }
    
    init?(data: Data) {
        guard let obj = try? JSONDecoder().decode(ResponseObject.self, from: data) else { return nil }
        self = obj
    }
    
    func key() -> String {
        return objectKey
    }
    
    func data() -> Data {
        return try! JSONEncoder().encode(self)
    }
}
