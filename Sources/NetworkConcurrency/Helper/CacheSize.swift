//
//  CacheSize.swift
//  NetworkConcurrency
//
//  Created by Hiral Naik on 1/30/26.
//

enum CacheSize {
    case small  // For Objects like Strings, Structs, JSONs
    case medium  // For Objects like Images, Data etc.
    case large  // For large Objects

    var maxDataSize: Int {
        switch self {
        case .small:
            return 1024 * 1024 * 5
        case .medium:
            return 1024 * 1024 * 25
        case .large:
            return 1024 * 1024 * 50
        }
    }
}
