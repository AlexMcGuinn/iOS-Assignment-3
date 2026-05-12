//
//  HomeView.swift
//  RecipeFinder
//
//  Created by Aung Ko Khaing on 6/5/2026.
//
import SwiftUI

struct HomeView: View {
    @State private var viewModel = RecipeSearchViewModel()
    @State private var searchText = ""
    @State private var searchSubmitted = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hi, User!")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("What's cooking today?")
                            .foregroundStyle(.secondary)
                    }

                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Search recipes...", text: $searchText)
                            .onSubmit {
                                if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                                    searchSubmitted = true
                                }
                            }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    // Upload photo button
                    NavigationLink(destination: UploadView()) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Find by Photo")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                    }

                    // Discover section
                    HStack {
                        Text("Discover")
                            .font(.headline)
                        Spacer()
                        Button {
                            Task { await viewModel.loadMultipleRandom(count: 6) }
                        } label: {
                            Text("Refresh")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                    } else if let error = viewModel.errorMessage {
                        ContentUnavailableView(error, systemImage: "fork.knife")
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(viewModel.meals) { meal in
                                NavigationLink(destination: RecipeDetailView(mealID: meal.idMeal)) {
                                    MealGridCard(meal: meal)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("RecipeFinder")
            .navigationDestination(isPresented: $searchSubmitted) {
                ResultsView(searchQuery: searchText)
            }
            .task { await viewModel.loadMultipleRandom(count: 6) }
        }
    }
}

struct MealGridCard: View {
    let meal: MealDBMeal

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            AsyncImage(url: meal.thumbnailURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color(.systemGray5)
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(meal.strMeal)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(2)
                .foregroundStyle(.primary)

            if let category = meal.strCategory {
                Text(category)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
