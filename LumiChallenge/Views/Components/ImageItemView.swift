//
//  ImageItemView.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//

import SwiftUI

struct ImageItemView: View {
    let image: ImageContent
    let level: Int

    @State private var showImageFullscreen = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(image.title)
                .font(font(for: .image, level: level))
                .padding(.leading, indent(for: level))

            AsyncImage(url: image.src) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: 100)
                case .success(let imageView):
                    imageView
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                        .cornerRadius(8)
                        .padding(.leading, indent(for: level))
                        .onTapGesture {
                            showImageFullscreen = true
                        }
                case .failure:
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                        .padding(.leading, indent(for: level))
                @unknown default:
                    EmptyView()
                }
            }
        }
        .sheet(isPresented: $showImageFullscreen) {
            FullScreenImageView(title: image.title, imageURL: image.src)
        }
    }

    private func font(for type: ItemType, level: Int) -> Font {
        switch type {
        case .page: return .title
        case .section: return level == 0 ? .title2 : .title3
        case .text, .image: return .body
        }
    }

    private func indent(for level: Int) -> CGFloat {
        CGFloat(level) * 16
    }
}

#Preview("ImageItemView") {
    ImageItemView(
        image: ImageContent(
            type: .image,
            title: "Preview Image",
            src: URL(string: "https://robohash.org/100?&set=set4&size=400x400")!
        ),
        level: 1
    )
    .padding()
}
