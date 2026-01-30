//
//  ObjectCacheService.swift
//  NetworkConcurrency
//
//  Created by Hiral Naik on 1/30/26.
//

import Foundation

actor ObjectCacheService: ObjectCacheProtocol {
    
    private let cache: NSCache<NSString, ObjectCacheBox>
    private let expirationInterval: TimeInterval = 300 // 5 Mins
    
    init(cacheSize: CacheSize = .small) {
        self.cache = NSCache<NSString, ObjectCacheBox>()
        self.cache.totalCostLimit = cacheSize.maxDataSize
    }
    
    func remove<T>(_ object: T) throws where T : ObjectCache {
        let key = compositeKey(object)
        
        guard cache.object(forKey: key) != nil else {
            throw CacheError.objectNotFound
        }
        
        cache.removeObject(forKey: key)
    }
    
    func retrieve<T>(_ key: String) throws -> T where T : ObjectCache {
        let key = compositeKey(type: T.self, key: key)
        
        guard let cachedObject = cache.object(forKey: key), let data = cachedObject.data, let object = T(data: data) else {
            throw CacheError.objectNotFound
        }
        
        let elapsed = Date().timeIntervalSince(cachedObject.timestamp)
        if expirationInterval < elapsed {
            try remove(object)
            throw CacheError.objectNotFound
        }
        
        return object
    }
    
    func store<T>(_ object: T) throws where T : ObjectCache {
        let key = compositeKey(object)
        let data = object.data()
        if let cachedObject = cache.object(forKey: key) {
            cachedObject.data = data
            cachedObject.timestamp = Date()
            cache.setObject(cachedObject, forKey: key)
        } else {
            let object = ObjectCacheBox(data: data, timestamp: Date())
            cache.setObject(object, forKey: key)
        }
    }
    
    func compositeKey<T: ObjectCache>(_ object: T) -> NSString {
        return compositeKey(type: T.self, key: object.key())
    }

    func compositeKey<T: ObjectCache>(type: T.Type, key: String) -> NSString {
        return "\(type)-\(key)" as NSString
    }
    
    func clear() {
        cache.removeAllObjects()
    }
}
