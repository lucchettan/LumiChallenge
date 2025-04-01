//
//  ImageContent.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//


import Foundation

struct ImageContent: Codable, Identifiable{
    let id = UUID()
    let type: ItemType
    let title: String
    let src: URL
}
