//
//  FullScreenImageView.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//

import SwiftUI

struct FullScreenImageView: View {
    let title: String
    let imageURL: URL

    @Environment(\.dismiss) private var dismiss

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var isZoomed = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top)

                    Spacer()

                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(scale)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            scale = lastScale * value
                                        }
                                        .onEnded { _ in
                                            withAnimation(.spring()) {
                                                scale = 1.0
                                                lastScale = 1.0
                                                isZoomed = false
                                            }
                                        }
                                )
                                .onTapGesture(count: 2) {
                                    withAnimation(.easeInOut) {
                                        if isZoomed {
                                            scale = 1.0
                                            lastScale = 1.0
                                        } else {
                                            scale = 2.5
                                            lastScale = 2.5
                                        }
                                        isZoomed.toggle()
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                        case .failure:
                            VStack(spacing: 16) {
                                Image(systemName: "xmark.octagon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundColor(.gray)
                                
                                Text("Failed to load the image")
                                    .foregroundColor(.white)
                                
                                Button(action: {
                                    // Force AsyncImage to reload by creating a new instance
                                    let originalURL = imageURL
                                    withAnimation {
                                        Task {
                                            try? await Task.sleep(nanoseconds: 100_000_000)
                                            URLCache.shared.removeCachedResponse(for: URLRequest(url: originalURL))
                                            // This will trigger a re-render of AsyncImage
                                        }
                                    }
                                }) {
                                    Label("Reload", systemImage: "arrow.clockwise")
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 10)
                                        .background(Color.blue.opacity(0.6))
                                        .cornerRadius(8)
                                }
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }

                    Spacer()

                    Button(action: { dismiss() }) {
                        Text("Close")
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                    }
                    .padding(.bottom)
                }
                .padding()
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #else
            .toolbar(.hidden)
            #endif
        }
    }
}


#Preview("FullScreenImageView") {
    FullScreenImageView(
        title: "Preview Full Image",
        imageURL: URL(string: "https://robohash.org/100?&set=set4&size=400x400")!
    )
}
