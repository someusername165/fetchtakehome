//
//  ContentView.swift
//  fetchtakehome
//
//  Created by Ahad Islam on 2/8/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var fetchViewModel: FetchViewModel
    
    init(fetchViewModel: FetchViewModel) {
        self.fetchViewModel = fetchViewModel
    }

    var body: some View {
        List(fetchViewModel.recipes) { recipe in
            RecipeRow(recipe: recipe)
        }
        .overlay(Group {
            if fetchViewModel.recipes.isEmpty {
                EmptyStateView {
                    await fetchViewModel.loadData()
                }
            }
        })
        .listRowSpacing(5.0)
        .refreshable {
            await fetchViewModel.loadData()
        }
    }
}

#Preview {
    ContentView(fetchViewModel: FetchViewModel())
}
