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
    @State private var duplicates: [PHAsset] = []
    @State private var showDuplicatesView: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
//                Button(action: {
//                    isImagePickerPresented.toggle()
//                }) {
//                    Text("Upload Photo")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .sheet(isPresented: $isImagePickerPresented) {
//                    ImagePicker(selectedImage: $selectedImage)
//                }

                NavigationLink(destination: PhotosView()) {
                                    Text("PhotoSwiper")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
//                if let selectedImage = selectedImage {
//                    Image(uiImage: selectedImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 300)
//                        .padding()
//                }

                // Buttons for each task
                NavigationLink(destination: AlbumsView()) {
                    Text("View Albums")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                                    findDuplicates()
                                }) {
                                    Text("Find Duplicates")
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .sheet(isPresented: $showDuplicatesView) {
                                    DuplicatesView(duplicates: duplicates)
                                }
//                Button(action: {
//                    // Action for applying filters
//                    applyFilters()
//                }) {
//                    Text("Apply Filters")
//                        .padding()
//                        .background(Color.purple)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//
//                Button(action: {
//                    // Action for creating a collage
//                    createCollage()
//                }) {
//                    Text("Create Collage")
//                        .padding()
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//
//                Button(action: {
//                    // Action for stitching panorama
//                    stitchPanorama()
//                }) {
//                    Text("Stitch Panorama")
//                        .padding()
//                        .background(Color.yellow)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//
//                Button(action: {
//                    // Action for extracting color palette
//                    extractColorPalette()
//                }) {
//                    Text("Extract Color Palette")
//                        .padding()
//                        .background(Color.cyan)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//
//                Button(action: {
//                    // Action for creating event albums
//                    createEventAlbums()
//                }) {
//                    Text("Create Event Albums")
//                        .padding()
//                        .background(Color.gray)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
                NavigationLink(destination: PhotoSelectionView()) {
                                    Text("Create Collage")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .padding()

                List {
//                    ForEach(photos, id: \.self) { photo in
//                        // Display photo thumbnail
//                        Text("Photo: \(photo.localIdentifier)")
//                    }
                }
            }
            .navigationTitle("Smart Photo Organizer")
            .onAppear {
                requestPhotoLibraryPermission()
                loadPhotos()
            }
        }
    }
    private func requestPhotoLibraryPermission() {
            print("Reached here")
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        print("Access granted to photo library.")
                    case .limited:
                        print("Limited access granted to photo library.")
                
                    case .denied:
                        print("Access denied to photo library.")
                        // Show alert guiding the user to enable access in settings
                    case .notDetermined:
                        print("Authorization status not determined.")
                        // Retry authorization request if appropriate
                    case .restricted:
                        print("Access restricted (e.g., due to parental controls).")
                    @unknown default:
                        print("Unknown authorization status.")
                    }
                }
            }
        }

    private func loadPhotos() {
        let fetchOptions = PHFetchOptions()
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        print("Number of assets found: \(assets.count)") // Debugging line
        
        assets.enumerateObjects { (asset, _, _) in
            photos.append(asset)
//            print("Fetched asset: \(asset.localIdentifier)") // Debugging line
        }
    }

    private func findDuplicates() {
            duplicates = DuplicateFinder.findDuplicates(photos: photos)
            showDuplicatesView = !duplicates.isEmpty
            print("Find Duplicates tapped")
        }

//    private func applyFilters() {
//        // Implement the logic to apply filters
//        print("Apply Filters tapped")
//    }
//
//    private func createCollage() {
//        // Implement the logic to create a collage
//        print("Create Collage tapped")
//    }
//
//    private func stitchPanorama() {
//        // Implement the logic to stitch panorama
//        print("Stitch Panorama tapped")
//    }
//
//    private func extractColorPalette() {
//        // Implement the logic to extract color palette
//        print("Extract Color Palette tapped")
//    }
//
//    private func createEventAlbums() {
//        // Implement the logic to create event albums
//        print("Create Event Albums tapped")
//    }
}


#Preview {
    ContentView()
}
