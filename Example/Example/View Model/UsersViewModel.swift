//
//  UsersViewModel.swift
//  Example
//
//  Created by Hiral Naik on 1/30/26.
//

import Foundation
import Combine
import NetworkConcurrency

@MainActor
class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let service: UserService = UserService(service: NetworkService())
    
    func fetchUsers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            users = try await service.fetchUsers()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
