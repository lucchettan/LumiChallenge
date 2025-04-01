//
//  TextContent.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//


import Foundation

struct TextContent: Codable, Identifiable {
    let id = UUID()
    let type: ItemType
    let title: String
}
