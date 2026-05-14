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
                    VStack(alignment: .leading, spacing: 8) {

                        Text("RecipeFinder")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .opacity(0.7)

                        Text("Find your next meal")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Search ingredients or explore new recipes")
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
                    .background(Theme.card)
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)

                    // Upload photo button
                    NavigationLink(destination: UploadView()) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Find by Photo")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.primary)
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
                        .foregroundStyle(.white)
                    }

                    // Discover section
                    HStack {
                        Text("Discover")
                            .font(.headline)
                        Spacer()
                        Button {
                            Task { await viewModel.loadMultipleRandom(count: 6) }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.headline)
                                .foregroundStyle(Theme.primary)
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
            .background(Theme.background)
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
            .frame(height: 135)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text(meal.strMeal)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(2)
                .frame(height: 38, alignment: .top)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.primary)
            
            if let category = meal.strCategory {
                Text(category)
                    .font(.caption2)
                    .foregroundStyle(Color.gray.opacity(0.8))
            }
        }
        .frame(height: 205)
        .padding(10)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
    }
}

