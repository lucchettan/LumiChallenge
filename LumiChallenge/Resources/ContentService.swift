//
//  NetworkService.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchContent() async throws -> Item
}

final class NetworkService: NetworkServiceProtocol {
    func fetchContent() async throws -> Item {
        guard let url = URL(string: "https://mocki.io/v1/6c823976-465e-401e-ae8d-d657d278e98e") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        if let raw = String(data: data, encoding: .utf8) {
            print("📦 RAW JSON:\n\(raw)")
        }

        let decoder = JSONDecoder()
        do {
            let item = try decoder.decode(Item.self, from: data)
            return item
        } catch {
            print("❌ Decoding error: \(error)")
            throw error
        }
    }
}
