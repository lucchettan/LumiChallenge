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
    
    private let contentService: NetworkServiceProtocol

    var pages: [Page] { rootItem?.pages ?? [] }
    
    var navigationTitle: String { rootItem != nil ? pages[currentPageIndex].title : "Fetching Content" }
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.contentService = networkService
    }

    func fetchContent() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let item = try await contentService.fetchContent()
            self.rootItem = item
        } catch {
            self.errorMessage = "Failed to fetch content: \(error.localizedDescription)"
        }
    }
}
