//
//  Recipe.swift
//  RecipeFinder
//
//  Created by Alex McGuinn on 4/5/2026.
//

struct Recipe: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var ingredients: [Ingredient]
    var steps: [String]
    var cuisine: CuisineType
    var dietaryTags: [DietaryTag]
    var prepTime: Int       //minutes
    var cookTime: Int       //minutes
    var servings: Int       //rough estimate (~2)
    var isFavourited: Bool
}
