//
//  ResultsView.swift
//  RecipeFinder
//

import SwiftUI

struct ResultsView: View {
    @State private var viewModel = RecipeSearchViewModel()
    var ingredients: [String] = []
    var searchQuery: String = ""

    private var title: String {
        if !searchQuery.isEmpty { return "Results for \"\(searchQuery)\"" }
        if !ingredients.isEmpty { return "Based on your ingredients" }
        return "Discover"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                } else if let error = viewModel.errorMessage {
                    ContentUnavailableView(error, systemImage: "fork.knife")
                } else {
                    ForEach(viewModel.meals) { meal in
                        NavigationLink(destination: RecipeDetailView(mealID: meal.idMeal)) {
                            RecipeCard(meal: meal)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Results")
        .task {
            if !searchQuery.isEmpty {
                await viewModel.search(query: searchQuery)
            } else if !ingredients.isEmpty {
                await viewModel.searchByIngredients(ingredients)
            } else {
                await viewModel.loadRandom()
            }
        }
    }
}

struct RecipeCard: View {
    var meal: MealDBMeal

    var body: some View {
        HStack {
            AsyncImage(url: meal.thumbnailURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color(.systemGray5)
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(meal.strMeal)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                if let category = meal.strCategory {
                    Text(category)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
