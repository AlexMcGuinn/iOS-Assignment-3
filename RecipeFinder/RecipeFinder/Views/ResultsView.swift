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
        .background(Theme.background)
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
        HStack(spacing: 14) {
            AsyncImage(url: meal.thumbnailURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color(.systemGray5)
            }
            .frame(width: 96, height: 96)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 8) {
                if let category = meal.strCategory {
                    Text(category)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.primary.opacity(0.14))
                        .foregroundStyle(Theme.primary)
                        .clipShape(Capsule())
                }

                Text(meal.strMeal)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text("Tap to view ingredients and cooking steps")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .opacity(0.85)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Theme.primary)
        }
        .padding(14)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        
    }
}
