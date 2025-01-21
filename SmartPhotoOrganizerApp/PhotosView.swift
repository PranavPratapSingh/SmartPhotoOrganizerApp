import SwiftUI
import Photos

struct PhotosView: View {
    @State private var photos: [PHAsset] = []
    @State private var currentIndex: Int = 0 // Track the current photo index
    @State private var showImageOverlay: Bool = false // Control overlay visibility
    @State private var selectedImage: UIImage? // Store the selected image for the overlay
    
    var body: some View {
        ZStack {
            VStack {
                if !photos.isEmpty {
                    PhotoCell(asset: photos[currentIndex], onDelete: {
                        // Remove the photo from the array
                        photos.remove(at: currentIndex)
                        refreshPhoto() // Refresh to show a new random photo
                    }, onKeep: {
                        // Remove the photo from the array
                        photos.remove(at: currentIndex)
                        refreshPhoto() // Refresh to show a new random photo
                    })
                    .frame(maxHeight: .infinity) // Allow the photo to take full height
                    .onTapGesture {
                        loadImageForOverlay() // Load the image for the overlay
                        showImageOverlay.toggle() // Show the overlay
                    }
                    
                    HStack {
                        Button(action: {
                            if currentIndex > 0 {
                                currentIndex -= 1 // Go to the previous photo
                            }
                            refreshPhoto() // Refresh to show a new random photo
                        }) {
                            Text("Previous")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(currentIndex == 0) // Disable if at the first photo
                        
                        Spacer()
                        
                        Button(action: {
                            if currentIndex < photos.count - 1 {
                                currentIndex += 1 // Go to the next photo
                            }
                            refreshPhoto() // Refresh to show a new random photo
                        }) {
                            Text("Next")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(currentIndex == photos.count - 1) // Disable if at the last photo
                    }
                    .padding()
                } else {
                    Text("No photos available.")
                        .font(.headline)
                        .padding()
                }
            }
            
            // Overlay for displaying the selected image
            if showImageOverlay, let image = selectedImage {
                Color.black.opacity(0.8) // Background dimming
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showImageOverlay.toggle() // Hide overlay on tap
                    }
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            }
        }
        .navigationTitle("All Photos")
        .onAppear {
            loadPhotos()
        }
    }
    
    private func loadPhotos() {
        let fetchOptions = PHFetchOptions()
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var fetchedPhotos: [PHAsset] = []
        assets.enumerateObjects { (asset, _, _) in
            fetchedPhotos.append(asset)
        }
        
        // Shuffle the photos
        photos = fetchedPhotos.shuffled()
        refreshPhoto() // Show a random photo on load
    }
    
    private func refreshPhoto() {
        if !photos.isEmpty {
            currentIndex = Int.random(in: 0..<photos.count) // Select a random index
        }
    }
    
    private func loadImageForOverlay() {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        imageManager.requestImage(for: photos[currentIndex], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { (result, _) in
            if let result = result {
                selectedImage = result // Set the selected image for the overlay
            }
        }
    }
}
