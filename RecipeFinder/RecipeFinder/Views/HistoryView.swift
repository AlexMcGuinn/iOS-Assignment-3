//
//  HistoryView.swift
//  SnapRecipe
//
//  Created by Aung Ko Khaing on 6/5/2026.
//

import SwiftUI

struct HistoryView: View {
    @AppStorage("historyMeals") private var historyMealsData: Data = Data()

    @State private var meals: [MealDBMeal] = []
    @State private var isLoading = false

    private var historyIDs: [String] {
        (try? JSONDecoder().decode([String].self, from: historyMealsData)) ?? []
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    if isLoading {
                        ProgressView("Loading history...")
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)

                    } else if meals.isEmpty {
                        ContentUnavailableView(
                            "No history yet",
                            systemImage: "clock",
                            description: Text("Viewed recipes will appear here.")
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
            .navigationTitle("History")
            .task {
                await loadHistory()
            }
            .onChange(of: historyMealsData) {
                Task {
                    await loadHistory()
                }
            }
        }
    }

    private func loadHistory() async {
        isLoading = true
        var loadedMeals: [MealDBMeal] = []

        for id in historyIDs {
            if let meal = try? await MealDBService.shared.getMeal(id: id) {
                loadedMeals.append(meal)
            }
        }

        meals = loadedMeals
        isLoading = false
    }
}
