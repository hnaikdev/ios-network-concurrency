//
//  NetworkServiceProtocol.swift
//  NetworkConcurrency
//
//  Created by Hiral Naik on 1/30/26.
//

public protocol NetworkServiceProtocol: Actor {
    func request<T: Decodable>(_ request: NetworkRequestProtocol) async throws -> T
    func clearCache() async
}
