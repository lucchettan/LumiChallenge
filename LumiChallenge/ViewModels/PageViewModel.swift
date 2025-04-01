import SwiftUI

@MainActor
final class PageViewModel: ObservableObject {
    @Published private(set) var pages: [Page] = []
    @Published var currentPageIndex: Int = 0
    @Published var selectedImage: ImageSelection?
    
    init(item: Item) {
        self.pages = item.pages
    }
}

// MARK: - Image Selection
struct ImageSelection: Identifiable {
    let id = UUID()
    let url: URL
    let title: String
} 