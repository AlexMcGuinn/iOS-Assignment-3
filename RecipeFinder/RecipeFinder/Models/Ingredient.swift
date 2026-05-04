//
//  Ingredient.swift
//  RecipeFinder
//
//  Created by Alex McGuinn on 4/5/2026.
//

struct Ingredient: Identifiable, Codable {
    let id: UUID
    var name: String
    var quantity: Double
    var unit: MeasurementUnit
}
