//
//  ContentView.swift
//  SmartPhotoOrganizerApp
//
//  Created by Pranav Pratap Singh on 1/21/25.
//

import SwiftUI
import Photos

struct ContentView: View {
    @State private var photos: [PHAsset] = []
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    Text("Upload Photo")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $selectedImage)
                }

                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding()
                }

                // Buttons for each task
                Button(action: {
                    // Action for viewing albums
                    viewAlbums()
                }) {
                    Text("View Albums")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    // Action for finding duplicates
                    findDuplicates()
                }) {
                    Text("Find Duplicates")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    // Action for applying filters
                    applyFilters()
                }) {
                    Text("Apply Filters")
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    // Action for creating a collage
                    createCollage()
                }) {
                    Text("Create Collage")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    // Action for stitching panorama
                    stitchPanorama()
                }) {
                    Text("Stitch Panorama")
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    // Action for extracting color palette
                    extractColorPalette()
                }) {
                    Text("Extract Color Palette")
                        .padding()
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    // Action for creating event albums
                    createEventAlbums()
                }) {
                    Text("Create Event Albums")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                List {
                    ForEach(photos, id: \.self) { photo in
                        // Display photo thumbnail
                        Text("Photo: \(photo.localIdentifier)")
                    }
                }
            }
            .navigationTitle("Smart Photo Organizer")
            .onAppear {
                loadPhotos()
            }
        }
    }

    private func loadPhotos() {
        let photoManager = PhotoManager.shared
        photos = photoManager.fetchPhotos()
    }

    private func viewAlbums() {
        // Implement the logic to view albums
        print("View Albums tapped")
    }

    private func findDuplicates() {
        // Implement the logic to find duplicates
        print("Find Duplicates tapped")
    }

    private func applyFilters() {
        // Implement the logic to apply filters
        print("Apply Filters tapped")
    }

    private func createCollage() {
        // Implement the logic to create a collage
        print("Create Collage tapped")
    }

    private func stitchPanorama() {
        // Implement the logic to stitch panorama
        print("Stitch Panorama tapped")
    }

    private func extractColorPalette() {
        // Implement the logic to extract color palette
        print("Extract Color Palette tapped")
    }

    private func createEventAlbums() {
        // Implement the logic to create event albums
        print("Create Event Albums tapped")
    }
}

#Preview {
    ContentView()
}
