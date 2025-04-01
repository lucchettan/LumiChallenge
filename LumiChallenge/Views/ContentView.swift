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
            TabView(selection: $viewModel.currentPageIndex) {
                if let rootItem = viewModel.rootItem {
                    ForEach(Array(viewModel.pages.enumerated()), id: \.element.id) { index, page in
                        ScrollView {
                            VStack(alignment: .leading, spacing: 24) {
                                ForEach(page.items) { subItem in
                                    ItemView(item: subItem, level: 0)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .scrollIndicators(.hidden)
                        .tag(index)
                    }
                } else {
                    VStack {
                        if viewModel.isLoading {
                            ProgressView("Loading...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            Text("No content available.")
                                .padding()
                        }
                    }
                }
            }
            .accentColor(.blue)
            .animation(.easeIn)
            .background(.white) // Workaround to ensure the view spreads to the bottom edge of the screen
            .task {
                await viewModel.fetchContent()
            }
            .edgesIgnoringSafeArea([.bottom])
            .tabViewStyle(.page(indexDisplayMode: .always))
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


