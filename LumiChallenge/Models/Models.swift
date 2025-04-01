//
//  Models.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//

import Foundation

enum ItemType: String, Codable {
    case page
    case section
    case text
    case image
}

protocol DisplayableItem: Identifiable {}

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

struct Page: Codable, Identifiable, DisplayableItem {
    let id = UUID()
    let type: ItemType
    let title: String
    let items: [Item]
}

struct Section: Codable, Identifiable, DisplayableItem {
    let id = UUID()
    let type: ItemType
    let title: String
    let items: [Item]
}

struct TextContent: Codable, Identifiable, DisplayableItem {
    let id = UUID()
    let type: ItemType
    let title: String
}

struct ImageContent: Codable, Identifiable, DisplayableItem {
    let id = UUID()
    let type: ItemType
    let title: String
    let src: URL
}

// MARK: - Page Extraction
extension Item {
    /// Extracts all pages from the item structure, maintaining their hierarchy and content
    var pages: [Page] {
        switch self {
        case .page(let page):
            // If this is a page, return it and recursively process its items
            var extractedPages = [page]
            for item in page.items {
                extractedPages.append(contentsOf: item.pages)
            }
            return extractedPages
            
        case .section(let section):
            // For sections, recursively process their items
            return section.items.flatMap { $0.pages }
            
        case .text, .image:
            // Text and image items don't contain pages
            return []
        }
    }
}
