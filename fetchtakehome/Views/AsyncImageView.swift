//
//  AsyncImageView.swift
//  fetchtakehome
//
//  Created by Ahad Islam on 2/8/25.
//

import SwiftUI

struct AsyncImageView<Content: View>: View {
    @State private var phase: AsyncImagePhase = .empty
    
    @Environment(\.imageLoader) private var imageLoader
    
    init(url: URL, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.init(urlRequest: URLRequest(url: url), content: content)
    }
    
    init(urlRequest: URLRequest, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.source = urlRequest
        self.content = content
    }
    
    private let content: (AsyncImagePhase) -> Content
    let source: URLRequest

    var body: some View {
        content(phase)
            .task {
                await loadImage()
            }
    }
    
    func loadImage() async {
        do {
            let image = try await imageLoader.fetch(source)
            phase = .success(Image(uiImage: image))
        } catch {
            phase = .failure(error)
        }
    }
}

#Preview {
    let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
    return AsyncImageView(url: url) { phase in
        switch phase {
        case .empty:
            ProgressView()
        case .success(let image):
            image
        case .failure(let error):
            Text("\(url.path.replacingOccurrences(of: "/", with: "", options: NSString.CompareOptions.literal, range: nil))")
        @unknown default:
            Text("Construction")
        }
    }
}
