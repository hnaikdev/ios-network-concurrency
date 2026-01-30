//
//  ContentView.swift
//  Example
//
//  Created by Hiral Naik on 1/30/26.
//

import SwiftUI

struct UsersView: View {
    
    @StateObject private var viewModel = UsersViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let error = viewModel.errorMessage {
                VStack {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                    Button("Retry") {
                        Task {
                            await viewModel.fetchUsers()
                        }
                    }
                }
            } else {
                List(viewModel.users) { user in
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Users")
        .task {
            await viewModel.fetchUsers()
        }
    }
}
