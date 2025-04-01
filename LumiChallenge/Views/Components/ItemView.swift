//
//  ItemView.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//

import SwiftUI

struct ItemView: View {
    let item: Item
    let level: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            switch item {
            case .page(let page):
                Text(page.title)
                    .font(font(for: .page, level: level))
                    .padding(.leading, indent(for: level))

                ForEach(page.items) { subItem in
                    ItemView(item: subItem, level: level + 1)
                }

            case .section(let section):
                Text(section.title)
                    .font(font(for: .section, level: level))
                    .padding(.leading, indent(for: level))

                ForEach(section.items) { subItem in
                    ItemView(item: subItem, level: level + 1)
                }

            case .text(let textBlock):
                Text(textBlock.title)
                    .font(font(for: .text, level: level))
                    .padding(.leading, indent(for: level))

            case .image(let imageBlock):
                VStack(alignment: .leading, spacing: 4) {
                    Text(imageBlock.title)
                        .font(font(for: .image, level: level))
                    AsyncImage(url: imageBlock.src) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200)
                                .cornerRadius(8)
                        case .failure:
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.leading, indent(for: level))
                }
            }
        }
    }

    // Font scaling based on type and depth
    func font(for type: ItemType, level: Int) -> Font {
        switch type {
        case .page:
            return .title
        case .section:
            return level == 0 ? .title2 : .title3
        case .text, .image:
            return .body
        }
    }

    // Indentation based on nesting level
    func indent(for level: Int) -> CGFloat {
        CGFloat(level) * 16
    }
}

#Preview {
    let previewItem: Item = .page(Page(
        type: .page,
        title: "Main Page",
        items: [
            .section(Section(
                type: .section,
                title: "Introduction",
                items: [
                    .text(TextContent(
                        type: .text,
                        title: "Welcome to the main page!"
                    )),
                    .image(ImageContent(
                        type: .image,
                        title: "Welcome Image",
                        src: URL(string: "https://robohash.org/280?&set=set4&size=400x400")!
                    ))
                ]
            )),
            .section(Section(
                type: .section,
                title: "Chapter 1",
                items: [
                    .text(TextContent(
                        type: .text,
                        title: "This is the first chapter."
                    )),
                    .section(Section(
                        type: .section,
                        title: "Subsection 1.1",
                        items: [
                            .text(TextContent(
                                type: .text,
                                title: "This is a subsection under Chapter 1."
                            )),
                            .image(ImageContent(
                                type: .image,
                                title: "Chapter 1 Image",
                                src: URL(string: "https://robohash.org/100?&set=set4&size=400x400")!
                            ))
                        ]
                    ))
                ]
            )),
            .page(Page(
                type: .page,
                title: "Second Page",
                items: [
                    .section(Section(
                        type: .section,
                        title: "Chapter 2",
                        items: [
                            .text(TextContent(type: .text, title: "This is the second chapter.")),
                            .text(TextContent(type: .text, title: "What is the main topic of Chapter 2?"))
                        ]
                    ))
                ]
            ))
        ]
    ))

    return ScrollView {
        ItemView(item: previewItem, level: 0)
            .padding()
    }
}
