//
//  ResultsView.swift
//  SnapRecipe
//
//  Created by Aung Ko Khaing on 6/5/2026.
//
import SwiftUI
struct ResultsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Based on your receipt")
                    .font(.title3)
                    .fontWeight(.bold)

                RecipeCard(title: "Chicken & Broccoli Stir Fry", time: "20 min")
                RecipeCard(title: "Garlic Chicken Fried Rice", time: "25 min")
                RecipeCard(title: "Chicken & Veggie Rice Bowl", time: "30 min")

            }
            .padding()
        }
    }
}

struct RecipeCard: View {
    var title: String
    var time: String

    var body: some View {
        NavigationLink(destination: RecipeDetailView(title: title)) {
            HStack {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)

                VStack(alignment: .leading) {
                    Text(title)
                        .fontWeight(.semibold)

                    Text(time)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}
