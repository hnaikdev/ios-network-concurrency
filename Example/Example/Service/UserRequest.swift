//
//  UserRequest.swift
//  Example
//
//  Created by Hiral Naik on 1/30/26.
//

import NetworkConcurrency

struct UserRequest: NetworkRequestProtocol {
    var httpMethod: NetworkConcurrency.HTTPMethod { .get }
    var baseURL: String { "https://jsonplaceholder.typicode.com" }
    var path: String { "/users" }
    var cachePolicy: CachePolicy { .cacheFirst }
}
