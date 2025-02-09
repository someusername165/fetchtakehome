//
//  Recipe.swift
//  fetchtakehome
//
//  Created by Ahad Islam on 2/8/25.
//

import Foundation

struct RecipeList: Codable {
    let recipes: [RecipeCodable]
}

struct RecipeCodable: Codable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let uuid: String
    let sourceUrl: String?
    let youtubeUrl: String?
}

struct Recipe: Identifiable, Sendable {
    let id: UUID
    let cuisine: String
    let name: String
    let photoUrlLarge: URL?
    let photoUrlSmall: URL?
    let sourceUrl: URL?
    let youtubeUrl: URL?
    
    init(id: UUID, cuisine: String, name: String, photoUrlLarge: URL? = nil, photoUrlSmall: URL? = nil, sourceUrl: URL? = nil, youtubeUrl: URL? = nil) {
        self.id = id
        self.cuisine = cuisine
        self.name = name
        self.photoUrlLarge = photoUrlLarge
        self.photoUrlSmall = photoUrlSmall
        self.sourceUrl = sourceUrl
        self.youtubeUrl = youtubeUrl
    }
    
    init?(codableRecipe: RecipeCodable) {
        guard let id = UUID(uuidString: codableRecipe.uuid) else { return nil }
        self.id = id
        self.cuisine = codableRecipe.cuisine
        self.name = codableRecipe.name
        self.photoUrlLarge = URL(string: codableRecipe.photoUrlLarge ?? "")
        self.photoUrlSmall = URL(string: codableRecipe.photoUrlSmall ?? "")
        self.sourceUrl = URL(string: codableRecipe.sourceUrl ?? "")
        self.youtubeUrl = URL(string: codableRecipe.youtubeUrl ?? "")
    }
}
