//
//  AsyncImageContainerView.swift
//  fetchtakehome
//
//  Created by Ahad Islam on 2/8/25.
//

import SwiftUI

struct AsyncImageContainerView: View {
    let url: URL
    var body: some View {
        AsyncImageView(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure(let error):
                Text("\(error)")
            @unknown default:
                Text("Construction")
            }
        }
    }
}

#Preview {
    AsyncImageContainerView(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!)
}
