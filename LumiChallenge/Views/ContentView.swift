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
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if let rootItem = viewModel.rootItem {
                PageView(item: rootItem)
                    .ignoresSafeArea()
            } else {
                Text("No content available.")
                    .padding()
            }
        }
        .task {
            await viewModel.fetchContent()
        }
    }
}


