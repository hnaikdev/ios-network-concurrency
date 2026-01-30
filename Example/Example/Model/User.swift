//
//  User.swift
//  Example
//
//  Created by Hiral Naik on 1/30/26.
//

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
}
