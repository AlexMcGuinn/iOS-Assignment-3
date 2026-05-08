//
//  HistoryView.swift
//  SnapRecipe
//
//  Created by Aung Ko Khaing on 6/5/2026.
//

import SwiftUI
struct HistoryView: View {
    var body: some View {
        NavigationView {
            List {
                Text("Chicken & Broccoli Stir Fry")
                Text("Garlic Chicken Fried Rice")
                Text("Chicken & Veggie Rice Bowl")
            }
            .navigationTitle("Your History")
        }
    }
}
