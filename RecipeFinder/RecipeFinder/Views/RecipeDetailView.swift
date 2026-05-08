//
//  RecipeDetailView.swift
//  SnapRecipe
//
//  Created by Aung Ko Khaing on 6/5/2026.
//
import SwiftUI
struct RecipeDetailView: View {
    var title: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Image(systemName: "photo")
                    .resizable()
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))

                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Ingredients")
                    .font(.headline)

                VStack(alignment: .leading) {
                    Text("• Chicken breast - 500g")
                    Text("• Broccoli - 1 head")
                    Text("• Garlic - 2 cloves")
                    Text("• Olive oil - 2 tbsp")
                }

                Button {
                } label: {
                    Text("Add to Favorites")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
    }
}
