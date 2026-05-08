//
//  HomeView.swift
//  SnapRecipe
//
//  Created by Aung Ko Khaing on 6/5/2026.
//
import SwiftUI

struct HomeView: View {

    @State private var showUpload = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                // Header
                VStack(alignment: .leading, spacing: 5) {
                    Text("Hi, User!")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("What’s cooking today?")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Illustration
                Image(systemName: "cart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .foregroundColor(.green)
                    .padding(.vertical, 10)
            

                // Direct Gallery Button
                NavigationLink(destination: UploadView()) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Choose from Gallery")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }

                // Recent Section
                VStack(alignment: .leading, spacing: 10) {

                    HStack {
                        Text("Recent")
                            .font(.headline)

                        Spacer()

                        Text("See all")
                            .font(.caption)
                            .foregroundColor(.green)
                    }

                    NavigationLink(destination: RecipeDetailView(title: "Chicken & Veg Stir Fry")) {
                        HStack {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)

                            VStack(alignment: .leading) {
                                Text("Chicken & Veg Stir Fry")
                                    .fontWeight(.medium)

                                Text("Matched 2 days ago")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }

                Spacer()
            }
            .padding()
        }
    }
}
