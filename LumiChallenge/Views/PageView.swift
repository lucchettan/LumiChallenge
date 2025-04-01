import SwiftUI

struct PageView: View {
    let item: Item
    @StateObject private var viewModel: PageViewModel
    
    init(item: Item) {
        self.item = item
        _viewModel = StateObject(wrappedValue: PageViewModel(item: item))
    }
    
    var body: some View {
        TabView(selection: $viewModel.currentPageIndex) {
            ForEach(Array(viewModel.pages.enumerated()), id: \.element.id) { index, page in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Page title
                        Text(page.title)
                            .font(.system(.title, design: .rounded).weight(.bold))
                            .foregroundColor(.primary)
                            .padding(.bottom, 8)
                        
                        // Page content
                        ForEach(page.items) { subItem in
                            ItemView(item: subItem, level: 0)
                        }
                    }
                    .padding()
                }
//                .background(.background)
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .sheet(item: $viewModel.selectedImage) { selection in
            FullScreenImageView(title: selection.title, imageURL: selection.url)
        }
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
    
    return PageView(item: previewItem)
} 
