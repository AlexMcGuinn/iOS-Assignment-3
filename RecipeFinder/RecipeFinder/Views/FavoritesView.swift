//
//  FavoritesView.swift
//  SnapRecipe
//
//  Created by Aung Ko Khaing on 6/5/2026.
//

import SwiftUI

struct FavoritesView: View {
    @AppStorage("favouriteMeals") private var favouriteMealsData: Data = Data()

    @State private var meals: [MealDBMeal] = []
    @State private var isLoading = false

    private var favouriteIDs: [String] {
        (try? JSONDecoder().decode([String].self, from: favouriteMealsData)) ?? []
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if isLoading {
                        ProgressView("Loading favourites...")
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)

                    } else if meals.isEmpty {
                        ContentUnavailableView(
                            "No favourites yet",
                            systemImage: "heart",
                            description: Text("Save recipes from the detail page to view them here.")
                        )
                        .padding(.top, 80)

                    } else {
                        ForEach(meals) { meal in
                            NavigationLink(destination: RecipeDetailView(mealID: meal.idMeal)) {
                                RecipeCard(meal: meal)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("Favorites")
            .task {
                await loadFavourites()
            }
            .onChange(of: favouriteMealsData) {
                Task {
                    await loadFavourites()
                }
            }
        }
    }

    private func loadFavourites() async {
        isLoading = true
        var loadedMeals: [MealDBMeal] = []

        for id in favouriteIDs {
            if let meal = try? await MealDBService.shared.getMeal(id: id) {
                loadedMeals.append(meal)
            }
        }

        meals = loadedMeals
        isLoading = false
    }
}
