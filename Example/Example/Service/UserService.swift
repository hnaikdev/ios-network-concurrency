//
//  UserService.swift
//  Example
//
//  Created by Hiral Naik on 1/30/26.
//

import NetworkConcurrency

class UserService {
    
    let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        self.service = service
    }
    
    func fetchUsers() async throws -> [User] {
        do {
            let request = UserRequest()
            let users: [User] = try await service.request(request)
            return users
        } catch {
            throw error
        }
    }
}
