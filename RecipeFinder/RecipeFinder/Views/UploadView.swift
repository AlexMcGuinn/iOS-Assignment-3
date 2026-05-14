//
//  UploadView.swift
//  SnapRecipe
//
//  Created by Aung Ko Khaing on 6/5/2026.
//
import SwiftUI

struct UploadView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Upload Receipt")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                // Image preview
                ZStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(16)
                    } else {
                        Rectangle()
                            .fill(Color(red: 0.93, green: 0.93, blue: 0.91))
                            .frame(height: 300)
                            .overlay(Text("No Image Selected"))
                            .cornerRadius(16)
                    }
                }

                // Buttons
                HStack {
                    Button {
                        sourceType = .camera
                        showImagePicker = true
                    } label: {
                        Label("Take Photo", systemImage: "camera")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.card)
                            .cornerRadius(18)
                    }

                    Button {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    } label: {
                        Label("Gallery", systemImage: "photo")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.card)
                            .cornerRadius(18)
                    }
                }

                .padding()

                // Upload button
                Button("Upload") {
                    print("Image uploaded!")
                }
                .disabled(selectedImage == nil)
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedImage == nil ? Color.gray.opacity(0.4) : Theme.primary)
                .foregroundColor(.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)

                Spacer()
            }
            .padding()
            .background(Theme.background)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
        }
    }
}
