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
    @AppStorage("favouriteMeals") private var favouriteMealsData: Data = Data()
    @AppStorage("historyMeals") private var historyMealsData: Data = Data()

    @State private var isFavourited = false

    var body: some View {
        ScrollView {
            if isLoading {
                VStack(spacing: 12) {
                    ProgressView()

                    Text("Loading recipe...")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 100)

            } else if let error = errorMessage {
                ContentUnavailableView(error, systemImage: "fork.knife")

            } else if let meal {
                VStack(alignment: .leading, spacing: 0) {
                    // Thumbnail
                    AsyncImage(url: meal.thumbnailURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color(.systemGray5)
                    }
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        LinearGradient(
                            colors: [
                                .clear,
                                Color.black.opacity(0.25)
                            ],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    )
                    .clipped()

                    VStack(alignment: .leading, spacing: 20) {
                        // Title + meta
                        VStack(alignment: .leading, spacing: 6) {
                            Text(meal.strMeal)
                                .font(.system(size: 30, weight: .bold, design: .rounded))

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
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ingredients")
                                .font(.headline)

                            ForEach(meal.ingredientList, id: \.name) { item in
                                HStack {
                                    Text(item.name)

                                    Spacer()

                                    Text(item.measure)
                                        .foregroundStyle(.secondary)
                                }
                                .font(.subheadline)
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .background(Theme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)

                        Divider()

                        // Instructions
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Instructions")
                                .font(.headline)

                            ForEach(Array(meal.steps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 14) {

                                    Text("\(index + 1)")
                                        .font(.subheadline.bold())
                                        .foregroundStyle(.white)
                                        .frame(width: 34, height: 34)
                                        .background(Theme.primary)
                                        .clipShape(Circle())

                                    Text(step)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .padding()
                        .background(Theme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)

                        // YouTube link
                        if let youtubeURL = meal.youtubeURL {
                            Link(destination: youtubeURL) {
                                Label("Watch on YouTube", systemImage: "play.circle")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red.opacity(0.1))
                                    .foregroundStyle(.red)
                                    .cornerRadius(24)
                            }
                        }

                        // Favourite button
                        Button {
                            isFavourited.toggle()

                            var favourites = (
                                try? JSONDecoder().decode([String].self, from: favouriteMealsData)
                            ) ?? []

                            if isFavourited {
                                if !favourites.contains(mealID) {
                                    favourites.append(mealID)
                                }
                            } else {
                                favourites.removeAll { $0 == mealID }
                            }

                            if let encoded = try? JSONEncoder().encode(favourites) {
                                favouriteMealsData = encoded
                            }
                        } label: {
                            Label(
                                isFavourited ? "Saved to Favourites" : "Add to Favourites",
                                systemImage: isFavourited ? "heart.fill" : "heart"
                            )
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.primary)
                            .foregroundStyle(.white)
                            .cornerRadius(24)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(meal?.strMeal ?? "Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .task {
            do {
                meal = try await MealDBService.shared.getMeal(id: mealID)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
            let favourites = (
                try? JSONDecoder().decode([String].self, from: favouriteMealsData)
            ) ?? []

            isFavourited = favourites.contains(mealID)
            
            var history = (
                try? JSONDecoder().decode([String].self, from: historyMealsData)
            ) ?? []

            history.removeAll { $0 == mealID }
            history.insert(mealID, at: 0)

            if history.count > 20 {
                history = Array(history.prefix(20))
            }

            if let encoded = try? JSONEncoder().encode(history) {
                historyMealsData = encoded
            }
        }
    }
}
