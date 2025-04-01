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
        VStack(alignment: .leading, spacing: 16) {
            switch item {
            case .page(let page):
                VStack(alignment: .leading, spacing: 12) {
                    Text(page.title)
                        .font(.system(.title, design: .rounded).weight(.semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(page.items) { subItem in
                        ItemView(item: subItem, level: level + 1)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)

            case .section(let section):
                VStack(alignment: .leading, spacing: 12) {
                    Text(section.title)
                        .font(.system(.title3, design: .rounded).weight(.medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(section.items) { subItem in
                        ItemView(item: subItem, level: level + 1)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 0.5)
                        .foregroundStyle(Color.gray.opacity(0.2))
                        .shadow(color: .black.opacity(0.5), radius: 18, x: 4, y: 8)
                )
                .cornerRadius(16)


            case .text(let text):
                Text(text.title)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            case .image(let image):
                ImageItemView(image: image, level: level)
            }
        }
        .frame(maxWidth: .infinity)
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
