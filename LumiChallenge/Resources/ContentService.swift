//
//  NetworkService.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
    case offline
    case serverError(statusCode: Int)
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode data"
        case .offline:
            return "No internet connection"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        }
    }
}

protocol NetworkServiceProtocol {
    func fetchContent() async throws -> Item
}

final class NetworkService: NetworkServiceProtocol {
    private let cacheService: CacheServiceProtocol
    private let apiURL = "https://mocki.io/v1/6c823976-465e-401e-ae8d-d657d278e98e"
    
    init(cacheService: CacheServiceProtocol = CacheService()) {
        self.cacheService = cacheService
    }
    
    func fetchContent() async throws -> Item {
        // First, try to fetch from the network
        do {
            let item = try await fetchFromNetwork()
            // If successful, save to cache
            await cacheService.saveContent(item)
            return item
        } catch NetworkError.offline {
            // If offline, try to load from cache
            print("📱 Offline mode: Attempting to load from cache")
            if let cachedItem = await cacheService.loadContent() {
                return cachedItem
            } else {
                // If no cache available, propagate the offline error
                throw NetworkError.offline
            }
        } catch {
            // For other errors, try to load from cache as fallback
            print("🌐 Network error: \(error.localizedDescription), attempting to load from cache")
            if let cachedItem = await cacheService.loadContent() {
                return cachedItem
            } else {
                // If no cache available, propagate the original error
                throw error
            }
        }
    }
    
    private func fetchFromNetwork() async throws -> Item {
        guard let url = URL(string: apiURL) else {
            throw NetworkError.badURL
        }
        
        // Check network connectivity
        if !isConnectedToNetwork() {
            throw NetworkError.offline
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        // Check for success status code
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        do {
            let item = try decoder.decode(Item.self, from: data)
            return item
        } catch {
            print("❌ Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
    
    // Simple network connectivity check
    private func isConnectedToNetwork() -> Bool {
        // In a real app, use NWPathMonitor or Reachability
        // This is a simplified version for demo purposes
        return true
    }
}
