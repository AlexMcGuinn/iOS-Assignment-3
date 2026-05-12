//
//  MealDBService.swift
//  RecipeFinder
//

import Foundation

enum MealDBError: LocalizedError {
    case invalidURL
    case noResults
    case decodingFailed(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid request URL."
        case .noResults: return "No meals found."
        case .decodingFailed: return "Failed to parse response."
        case let .networkError(e): return e.localizedDescription
        }
    }
}

final class MealDBService {
    static let shared = MealDBService()

    //Using TheMealDB free tier does not require api keys, just the baseURL is fine
    // API reference: https://www.themealdb.com/documentation#list
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        session = URLSession(configuration: config)
    }

    func searchMeals(query: String) async throws -> [MealDBMeal] {
        let meals = try await fetch(MealDBResponse.self, path: "/search.php", queryItems: [
            URLQueryItem(name: "s", value: query),
        ])
        guard let results = meals.meals, !results.isEmpty else { throw MealDBError.noResults }
        return results
    }

    func getMeal(id: String) async throws -> MealDBMeal {
        let response = try await fetch(MealDBResponse.self, path: "/lookup.php", queryItems: [
            URLQueryItem(name: "i", value: id),
        ])
        guard let meal = response.meals?.first else { throw MealDBError.noResults }
        return meal
    }

    func getMealsByIngredient(_ ingredient: String) async throws -> [MealDBMeal] {
        let response = try await fetch(MealDBResponse.self, path: "/filter.php", queryItems: [
            URLQueryItem(name: "i", value: ingredient),
        ])
        guard let results = response.meals, !results.isEmpty else { throw MealDBError.noResults }
        return results
    }

    func getMealsByIngredients(_ ingredients: [String]) async throws -> [MealDBMeal] {
        // TheMealDB free tier only supports filtering by one ingredient per request.
        // Therefore, query each ingredient separately then intersect the results,
        // so we only return recipes that contain ALL of the given ingredients.

        // Example: ingredients = ["chicken breast", "garlic", "salt"]
        //   1st request: /filter.php?i=chicken_breast
        //   2nd request: /filter.php?i=garlic
        //   3rd request: /filter.php?i=salt
        //   Final result outputs recipes that appear in all three responses
        var resultSets: [Set<String>] = []
        var mealMap: [String: MealDBMeal] = [:]

        for ingredient in ingredients {
            guard let results = try? await getMealsByIngredient(ingredient) else { continue }
            resultSets.append(Set(results.map { $0.idMeal }))
            for meal in results { mealMap[meal.idMeal] = meal }
        }

        guard let first = resultSets.first else { throw MealDBError.noResults }
        let intersection = resultSets.dropFirst().reduce(first) { $0.intersection($1) }
        let results = intersection.compactMap { mealMap[$0] }

        guard !results.isEmpty else { throw MealDBError.noResults }
        return results
    }

    func getRandomMeal() async throws -> MealDBMeal {
        let response = try await fetch(MealDBResponse.self, path: "/random.php", queryItems: [])
        guard let meal = response.meals?.first else { throw MealDBError.noResults }
        return meal
    }

    func getCategories() async throws -> [MealDBCategory] {
        let response = try await fetch(MealDBCategoryResponse.self, path: "/categories.php", queryItems: [])
        return response.categories
    }

    private func fetch<T: Decodable>(_ type: T.Type, path: String, queryItems: [URLQueryItem]) async throws -> T {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems

        guard let url = components?.url else { throw MealDBError.invalidURL }

        let data: Data
        do {
            let (responseData, _) = try await session.data(from: url)
            data = responseData
        } catch {
            throw MealDBError.networkError(error)
        }

        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw MealDBError.decodingFailed(error)
        }
    }
}
