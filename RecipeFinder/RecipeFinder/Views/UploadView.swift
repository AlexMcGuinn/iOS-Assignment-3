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
        NavigationView {
            VStack(spacing: 20) {
                Text("Upload Receipt")
                    .font(.headline)
                    .accessibilityIdentifier("uploadHeading")

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
                            .fill(Color(.systemGray5))
                            .frame(height: 300)
                            .overlay(Text("No Image Selected"))
                            .cornerRadius(16)
                    }
                }

                // Buttons
                HStack {
                    Button("Take Photo") {
                        sourceType = .camera
                        showImagePicker = true
                    }

                    Button("Gallery") {
                        sourceType = .photoLibrary
                        showImagePicker = true
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
                .background(selectedImage == nil ? Color.gray : Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)

                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
        }
    }
}
