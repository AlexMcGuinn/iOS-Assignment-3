//
//  RecipeSearchViewModel.swift
//  RecipeFinder
//
//  Created by Alex McGuinn on 4/5/2026.
//

import Foundation
import Observation

@Observable
final class RecipeSearchViewModel {
    var meals: [MealDBMeal] = []
    var selectedMeal: MealDBMeal?
    var isLoading = false
    var errorMessage: String?

    private let service = MealDBService.shared

    // MARK: - Search

    func search(query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        await run { try await self.service.searchMeals(query: query) }
    }

    func searchByIngredient(_ ingredient: String) async {
        await run { try await self.service.getMealsByIngredient(ingredient) }
    }

    func searchByIngredients(_ ingredients: [String]) async {
        await run { try await self.service.getMealsByIngredients(ingredients) }
    }

    func loadRandom() async {
        isLoading = true
        errorMessage = nil
        do {
            let meal = try await service.getRandomMeal()
            meals = [meal]
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func loadMultipleRandom(count: Int) async {
        isLoading = true
        errorMessage = nil
        await withTaskGroup(of: MealDBMeal?.self) { group in
            for _ in 0 ..< count {
                group.addTask { try? await self.service.getRandomMeal() }
            }
            var results: [MealDBMeal] = []
            for await meal in group {
                if let meal { results.append(meal) }
            }
            meals = Array(
                Dictionary(grouping: results, by: \.idMeal)
                    .compactMap { $0.value.first }
            )
        }
        isLoading = false
    }


    func loadDetail(id: String) async {
        isLoading = true
        errorMessage = nil
        do {
            selectedMeal = try await service.getMeal(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    private func run(_ fetch: @escaping () async throws -> [MealDBMeal]) async {
        isLoading = true
        errorMessage = nil
        do {
            meals = try await fetch()
        } catch MealDBError.noResults {
            meals = []
            errorMessage = "No meals found."
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
