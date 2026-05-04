//
//  Enums.swift
//  RecipeFinder
//
//  Created by Alex McGuinn on 4/5/2026.
//

enum CuisineType: String, Codable, CaseIterable {
    case italian, asian, mexican, mediterranean, american, other
}

enum DietaryTag: String, Codable, CaseIterable {
    case vegetarian, vegan, glutenFree, dairyFree, keto, paleo
}

enum MeasurementUnit: String, Codable {
    case grams, kilograms, ml, litres, tsp, tbsp, cup, piece
}
