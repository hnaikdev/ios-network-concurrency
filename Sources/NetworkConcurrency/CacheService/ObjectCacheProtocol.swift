//
//  ObjectCacheProtocol.swift
//  NetworkConcurrency
//
//  Created by Hiral Naik on 1/30/26.
//

import Foundation

public enum CacheError: Error {
    case objectNotFound
    case removeFailed
    case retrieveFailed
    case storeFailed
}

protocol ObjectCacheProtocol: Actor {

    // Remove the object from the cache
    func remove<T: ObjectCache>(_ object: T) throws

    // Retrieve the object from the cache
    func retrieve<T: ObjectCache>(_ key: String) throws -> T

    // Store the object in the cache
    func store<T: ObjectCache>(_ object: T) throws
    
    func clear()
}
