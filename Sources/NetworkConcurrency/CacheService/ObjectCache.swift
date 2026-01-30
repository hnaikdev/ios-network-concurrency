//
//  ObjectCache.swift
//  NetworkConcurrency
//
//  Created by Hiral Naik on 1/30/26.
//

import Foundation

protocol ObjectCache {
    init?(data: Data)
    func key() -> String
    func data() -> Data
}

class ObjectCacheBox {
    var data: Data?
    var timestamp: Date

    init(data: Data? = nil, timestamp: Date) {
        self.data = data
        self.timestamp = timestamp
    }
}
