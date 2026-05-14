//
//  ProfileView.swift
//  SnapRecipe
//
//  Created by Aung Ko Khaing on 6/5/2026.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("favouriteMeals") private var favouriteMealsData: Data = Data()
    @AppStorage("historyMeals") private var historyMealsData: Data = Data()

    private var favouriteCount: Int {
        (
            try? JSONDecoder().decode([String].self, from: favouriteMealsData)
        )?.count ?? 0
    }

    private var historyCount: Int {
        (
            try? JSONDecoder().decode([String].self, from: historyMealsData)
        )?.count ?? 0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 90, height: 90)
                            .foregroundStyle(Theme.primary)

                        Text("SnapRecipe User")
                            .font(.title2.bold())

                        Text("Discover recipes from your ingredients")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)

                    HStack(spacing: 16) {

                        StatCard(
                            title: "Favourites",
                            value: "\(favouriteCount)",
                            icon: "heart.fill",
                            color: .red
                        )

                        StatCard(
                            title: "History",
                            value: "\(historyCount)",
                            icon: "clock.fill",
                            color: .blue
                        )
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.headline)

                        Text("SnapRecipe helps users discover recipes by searching ingredients or analysing receipts.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Theme.card)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("Profile")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.title.bold())

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}
