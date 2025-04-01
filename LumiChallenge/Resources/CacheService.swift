//
//  CacheService.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//

import Foundation

protocol CacheServiceProtocol {
    func saveContent(_ item: Item) async
    func loadContent() async -> Item?
    func clearCache() async
}

final class CacheService: CacheServiceProtocol {
    private let fileManager = FileManager.default
    private let cacheKey = "cached_content"
    
    private var cacheURL: URL {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDirectory.appendingPathComponent("\(cacheKey).json")
    }
    
    func saveContent(_ item: Item) async {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(item)
            try data.write(to: cacheURL)
            print("✅ Content saved to cache")
        } catch {
            print("❌ Failed to save content to cache: \(error.localizedDescription)")
        }
    }
    
    func loadContent() async -> Item? {
        guard fileManager.fileExists(atPath: cacheURL.path) else {
            print("⚠️ No cached content found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: cacheURL)
            let decoder = JSONDecoder()
            let item = try decoder.decode(Item.self, from: data)
            print("✅ Content loaded from cache")
            return item
        } catch {
            print("❌ Failed to load content from cache: \(error.localizedDescription)")
            return nil
        }
    }
    
    func clearCache() async {
        guard fileManager.fileExists(atPath: cacheURL.path) else { return }
        
        do {
            try fileManager.removeItem(at: cacheURL)
            print("✅ Cache cleared")
        } catch {
            print("❌ Failed to clear cache: \(error.localizedDescription)")
        }
    }
} 