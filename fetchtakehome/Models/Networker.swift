//
//  Networker.swift
//  fetchtakehome
//
//  Created by Ahad Islam on 2/8/25.
//

import Foundation

enum NetworkError: Error {
    case failToCreateUrl(String)
}

enum RecipeError: Error {
    case failedToCreateRecipe(RecipeList)
    case failedToCreateRecipeFromCodable(String)
}

protocol RecipeGetter {
    func getRecipes() async throws -> [Recipe]
}

@globalActor
actor Networker: RecipeGetter {
    
    private init() {}
    
    private func downloadModels() async throws -> Data   {
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        guard let url = URL(string: urlString) else {
            throw NetworkError.failToCreateUrl(urlString)
        }
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        return data
    }
    
    private func decode(data: Data) async throws -> [Recipe] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let list = try decoder.decode(RecipeList.self, from: data)
        let recipes = list.recipes.compactMap { codable in
            Recipe(codableRecipe: codable)
        }
        guard recipes.count == list.recipes.count else {
            throw RecipeError.failedToCreateRecipeFromCodable("Original list count was \(list.recipes.count) but converted recipes is :\(recipes.count)")
        }
        return recipes
    }
    
    func getRecipes() async throws -> [Recipe] {
        let data = try await downloadModels()
        return try await decode(data: data)
    }
    
    static let shared = Networker()
}
