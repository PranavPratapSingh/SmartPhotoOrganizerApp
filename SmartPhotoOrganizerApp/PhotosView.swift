import SwiftUI
import Photos

struct PhotosView: View {
    @State private var photos: [PHAsset] = []
    @State private var photosToBeDeleted: [PHAsset] = []
    @State private var currentIndex: Int = 0
    @State private var showImageOverlay: Bool = false
    @State private var selectedImage: UIImage?

    var body: some View {
        ZStack {
            VStack {
                if !photos.isEmpty {
                    PhotoCellTinder(asset: photos[currentIndex],onDelete: {
                        deletePhoto()
                    }, onKeep: {
                        keepPhoto()
                    })
                    .frame(maxHeight: .infinity)
                    .onTapGesture {
                        loadImageForOverlay(asset: photos[currentIndex])
                        showImageOverlay.toggle()
                    }
                    
                    HStack {
                        Button(action: {
                            deletePhoto() // Delete the current photo
                        }) {
                            Text("Delete")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                                deletePhotoArray()
                            }) {
                                Text("Done")
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        .padding()
                    
                        Spacer()
                    
                        
                        Button(action: {
                            keepPhoto() // Keep the current photo
                        }) {
                            Text("Keep")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
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
                Color.black.opacity(0.8)
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
        print("Loading photos...")
        let fetchOptions = PHFetchOptions()
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var fetchedPhotos: [PHAsset] = []
        assets.enumerateObjects { (asset, _, _) in
            fetchedPhotos.append(asset)
            print("Fetched photo: \(asset.localIdentifier)")
        }
        
        // Shuffle the photos
        photos = fetchedPhotos.shuffled()
        print("Total photos loaded: \(photos.count)")
        currentIndex = 0 // Start with the first photo
        print("Current index set to: \(currentIndex)")
    }
    
    private func loadImageForOverlay(asset: PHAsset) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { (result, _) in
            if let result = result {
                selectedImage = result // Set the selected image for the overlay
                print("Loaded image for overlay: \(asset.localIdentifier)")
            }
        }
    }
    private func deletePhotoArray() {
        guard !photosToBeDeleted.isEmpty else { return }
        
        print("Attempting to delete photoArray of size: \(photosToBeDeleted.count)")
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(photosToBeDeleted as NSArray)
        }) { success, error in
            if success {
                print("Deleted photos count: \(photosToBeDeleted.count)")
            }else if let error = error {
                print("Error deleting photo: \(error.localizedDescription)")
            }
        }
    }
    private func deletePhoto() {
        guard !photos.isEmpty else { return }
        
        let photoToDelete = photos[currentIndex]
        print("Attempting to delete photo: \(photoToDelete.localIdentifier)")
        photosToBeDeleted.append(photoToDelete)
        photos.remove(at: currentIndex)
        updateCurrentIndex()
    }
    
    private func keepPhoto() {
        guard !photos.isEmpty else { return }
        
        print("Keeping photo: \(photos[currentIndex].localIdentifier)")
        photos.remove(at: currentIndex) // Remove the current photo from the array
        updateCurrentIndex() // Update to show a new photo
    }
    
    private func updateCurrentIndex() {
        if photos.isEmpty {
            print("No photos left. Resetting current index to 0.")
            currentIndex = 0 // Reset to 0 if no photos left
        } else {
            // Ensure currentIndex is valid
            currentIndex = min(currentIndex, photos.count - 1)
            print("Updated current index to: \(currentIndex)")
        }
    }
}
