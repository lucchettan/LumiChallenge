//
//  ContentViewModel.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//

import Foundation

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var rootItem: Item? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var currentPageIndex: Int = 0
    @Published var isOfflineMode: Bool = false
    
    private let contentService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    var pages: [Page] { rootItem?.pages ?? [] }
    
    var navigationTitle: String { 
        if isOfflineMode && rootItem != nil {
            return "\(pages[currentPageIndex].title) (Offline)"
        } else {
            return rootItem != nil ? pages[currentPageIndex].title : "Fetching Content" 
        }
    }
    
    init(networkService: NetworkServiceProtocol = NetworkService(), 
         cacheService: CacheServiceProtocol = CacheService()) {
        self.contentService = networkService
        self.cacheService = cacheService
    }

    func fetchContent() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let item = try await contentService.fetchContent()
            self.rootItem = item
            self.errorMessage = nil
            self.isOfflineMode = false
        } catch let error as NetworkError {
            // Handle different network errors
            switch error {
            case .offline:
                // Try to load from cache
                if let cachedItem = await cacheService.loadContent() {
                    self.rootItem = cachedItem
                    self.isOfflineMode = true
                    self.errorMessage = nil
                } else {
                    self.errorMessage = "No internet connection and no cached content available."
                }
            case .serverError(let statusCode):
                self.errorMessage = "Server error with status code: \(statusCode). Please try again later."
                // Try to load from cache as fallback
                if let cachedItem = await cacheService.loadContent() {
                    self.rootItem = cachedItem
                    self.isOfflineMode = true
                }
            default:
                self.errorMessage = "Failed to fetch content: \(error.localizedDescription)"
                // Try to load from cache as fallback
                if let cachedItem = await cacheService.loadContent() {
                    self.rootItem = cachedItem
                    self.isOfflineMode = true
                }
            }
        } catch {
            self.errorMessage = "Failed to fetch content: \(error.localizedDescription)"
            // Try to load from cache as fallback
            if let cachedItem = await cacheService.loadContent() {
                self.rootItem = cachedItem
                self.isOfflineMode = true
            }
        }
    }
    
    func retryFetch() async {
        await fetchContent()
    }
}
