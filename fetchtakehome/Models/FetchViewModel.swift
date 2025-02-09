//
//  FetchViewModel.swift
//  fetchtakehome
//
//  Created by Ahad Islam on 2/8/25.
//

import Foundation

@MainActor
class FetchViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    func loadData() async {
        do {
            let recipes = try await Networker.shared.getRecipes()
            self.recipes = recipes
        } catch {
            // handle error here
        }
    }
}
