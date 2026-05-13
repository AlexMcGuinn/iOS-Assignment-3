//
//  RecipeDetailView.swift
//  RecipeFinder
//

import SwiftUI

struct RecipeDetailView: View {
    let mealID: String

    @State private var meal: MealDBMeal?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var isFavourited = false

    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)

            } else if let error = errorMessage {
                ContentUnavailableView(error, systemImage: "fork.knife")

            } else if let meal {
                VStack(alignment: .leading, spacing: 0) {
                    // Thumbnail
                    AsyncImage(url: meal.thumbnailURL) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color(.systemGray5)
                    }
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
                    .clipped()

                    VStack(alignment: .leading, spacing: 20) {
                        // Title + meta
                        VStack(alignment: .leading, spacing: 6) {
                            Text(meal.strMeal)
                                .font(.title2.bold())
                                .accessibilityIdentifier("recipeTitle")

                            HStack(spacing: 12) {
                                if let area = meal.strArea {
                                    Label(area, systemImage: "globe")
                                }
                                if let category = meal.strCategory {
                                    Label(category, systemImage: "tag")
                                }
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        Divider()

                        // Ingredients
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients")
                                .font(.headline)

                            ForEach(meal.ingredientList, id: \.name) { item in
                                HStack {
                                    Text("• \(item.name)")
                                    Spacer()
                                    Text(item.measure)
                                        .foregroundStyle(.secondary)
                                }
                                .font(.subheadline)
                            }
                        }

                        Divider()

                        // Instructions
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Instructions")
                                .font(.headline)

                            ForEach(Array(meal.steps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("\(index + 1).")
                                        .fontWeight(.semibold)
                                        .frame(width: 24, alignment: .leading)
                                    Text(step)
                                }
                                .font(.subheadline)
                            }
                        }

                        // YouTube link
                        if let youtubeURL = meal.youtubeURL {
                            Link(destination: youtubeURL) {
                                Label("Watch on YouTube", systemImage: "play.circle")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red.opacity(0.1))
                                    .foregroundStyle(.red)
                                    .cornerRadius(12)
                            }
                        }

                        // Favourite button
                        Button {
                            isFavourited.toggle()
                        } label: {
                            Label(
                                isFavourited ? "Saved to Favourites" : "Add to Favourites",
                                systemImage: isFavourited ? "heart.fill" : "heart"
                            )
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(meal?.strMeal ?? "Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                meal = try await MealDBService.shared.getMeal(id: mealID)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
