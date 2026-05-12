//
//  MealDBModels.swift
//  RecipeFinder
//
//  Created by Alex McGuinn on 11/5/2026.
//
import Foundation

struct MealDBResponse: Codable {
    let meals: [MealDBMeal]?
}

struct MealDBCategoryResponse: Codable {
    let categories: [MealDBCategory]
}

struct MealDBCategory: Codable, Identifiable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String

    var id: String {
        idCategory
    }
}

struct MealDBMeal: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?
    let strYoutube: String?
    let strTags: String?

    // TheMealDB encodes ingredients and measures as 20 numbered fields
    let strIngredient1: String?; let strIngredient2: String?; let strIngredient3: String?
    let strIngredient4: String?; let strIngredient5: String?; let strIngredient6: String?
    let strIngredient7: String?; let strIngredient8: String?; let strIngredient9: String?
    let strIngredient10: String?; let strIngredient11: String?; let strIngredient12: String?
    let strIngredient13: String?; let strIngredient14: String?; let strIngredient15: String?
    let strIngredient16: String?; let strIngredient17: String?; let strIngredient18: String?
    let strIngredient19: String?; let strIngredient20: String?

    let strMeasure1: String?; let strMeasure2: String?; let strMeasure3: String?
    let strMeasure4: String?; let strMeasure5: String?; let strMeasure6: String?
    let strMeasure7: String?; let strMeasure8: String?; let strMeasure9: String?
    let strMeasure10: String?; let strMeasure11: String?; let strMeasure12: String?
    let strMeasure13: String?; let strMeasure14: String?; let strMeasure15: String?
    let strMeasure16: String?; let strMeasure17: String?; let strMeasure18: String?
    let strMeasure19: String?; let strMeasure20: String?

    var id: String {
        idMeal
    }

    var ingredientList: [(name: String, measure: String)] {
        let names = [
            strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
            strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
            strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15,
            strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20,
        ]
        let measures = [
            strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
            strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
            strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15,
            strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20,
        ]
        return zip(names, measures).compactMap { name, measure in
            guard let name = name, !name.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
            return (name: name, measure: measure?.trimmingCharacters(in: .whitespaces) ?? "")
        }
    }

    var thumbnailURL: URL? {
        strMealThumb.flatMap {
            URL(string: $0)
        }
    }

    var youtubeURL: URL? {
        strYoutube.flatMap { URL(string: $0) }
    }

    var steps: [String] {
        guard let instructions = strInstructions else { return [] }
        return instructions
            .components(separatedBy: "\r\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}
