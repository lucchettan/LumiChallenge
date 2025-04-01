//
//  Item.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//


import Foundation

enum Item: Identifiable, Codable {
    case page(Page)
    case section(Section)
    case text(TextContent)
    case image(ImageContent)

    var id: UUID {
        switch self {
        case .page(let page): return page.id
        case .section(let section): return section.id
        case .text(let text): return text.id
        case .image(let image): return image.id
        }
    }
    
    var type: ItemType {
        switch self {
        case .page: return .page
        case .section: return .section
        case .text: return .text
        case .image: return .image
        }
    }

    enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ItemType.self, forKey: .type)

        switch type {
        case .page:
            self = .page(try Page(from: decoder))
        case .section:
            self = .section(try Section(from: decoder))
        case .text:
            self = .text(try TextContent(from: decoder))
        case .image:
            self = .image(try ImageContent(from: decoder))
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .page(let page): try page.encode(to: encoder)
        case .section(let section): try section.encode(to: encoder)
        case .text(let text): try text.encode(to: encoder)
        case .image(let image): try image.encode(to: encoder)
        }
    }
}

// MARK: - Page Extraction
extension Item {
    /// Extracts all pages from the item structure, maintaining their hierarchy and content
    var pages: [Page] {
        switch self {
        case .page(let page):
            // First, collect all nested pages
            var nestedPages: [Page] = []
            for item in page.items {
                nestedPages.append(contentsOf: item.pages)
            }
            
            // Create a new page with only non-page items
            let nonPageItems = page.items.filter { $0.type != .page }
            let currentPage = Page(type: page.type, title: page.title, items: nonPageItems)
            
            // Return the current page and all nested pages
            return [currentPage] + nestedPages
            
        case .section(let section):
            // For sections, process their items to extract any nested pages
            return section.items.flatMap { $0.pages }
            
        case .text, .image:
            return []
        }
    }
}
