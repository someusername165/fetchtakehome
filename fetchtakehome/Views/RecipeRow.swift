//
//  RecipeRow.swift
//  fetchtakehome
//
//  Created by Ahad Islam on 2/8/25.
//

import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    var body: some View {
        HStack(spacing: 5.0) {
            if let url = recipe.photoUrlSmall {
                AsyncImageContainerView(url: url)
                    .frame(maxWidth: 100.0)
            } else {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 100.0)
            }
            Text("\(recipe.name)")
            Text("\(recipe.cuisine)")
            Spacer()
        }
        .frame(maxHeight: 100)
        .background(Color.green.opacity(0.1))
    }
}

#Preview {
    VStack {
        RecipeRow(recipe: Recipe(id: UUID(), cuisine: "Bengali", name: "Chicken"))
        RecipeRow(recipe: Recipe(id: UUID(), cuisine: "BEEE", name: "MARSALA", photoUrlSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!))
    }
}
