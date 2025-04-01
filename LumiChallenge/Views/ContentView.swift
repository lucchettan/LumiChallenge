//
//  ContentView.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else if let rootItem = viewModel.rootItem {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ItemView(item: rootItem, level: 0)
                        }
                        .padding()
                    }
                } else {
                    Text("No content available.")
                        .padding()
                }
            }
            .navigationTitle("Content")
        }
        .task {
            await viewModel.fetchContent()
        }
    }
}


