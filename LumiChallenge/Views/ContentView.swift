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
                                // Show offline indicator if needed
                                if viewModel.isOfflineMode {
                                    HStack {
                                        Image(systemName: "wifi.slash")
                                            .foregroundColor(.orange)
                                        Text("Offline Mode - Content may not be up to date")
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                        Spacer()
                                        Button(action: {
                                            Task {
                                                await viewModel.retryFetch()
                                            }
                                        }) {
                                            Text("Retry")
                                                .font(.caption)
                                                .bold()
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(8)
                                    .background(Color.orange.opacity(0.1))
                                    .cornerRadius(6)
                                }
                                
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
                            VStack(spacing: 16) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 40))
                                    .foregroundColor(.orange)
                                
                                Text("Error loading content")
                                    .font(.headline)
                                
                                Text(error)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.secondary)
                                
                                Button("Try Again") {
                                    Task {
                                        await viewModel.retryFetch()
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            .padding()
                        } else {
                            Text("No content available.")
                                .padding()
                        }
                    }
                }
            }
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


