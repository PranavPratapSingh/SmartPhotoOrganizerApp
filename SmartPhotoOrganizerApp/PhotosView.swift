import SwiftUI
import Photos

struct PhotosView: View {
    @State private var photos: [PHAsset] = []
    @State private var currentIndex: Int = 0
    @State private var showImageOverlay: Bool = false
    @State private var selectedImage: UIImage?
    @State private var photoCell: PhotoCell?
    
    var body: some View {
        ZStack {
            VStack {
                if !photos.isEmpty {
                    
                    if let photoCell{
                        
                        photoCell.frame(maxHeight: .infinity)
                            .onTapGesture {
                                loadImageForOverlay()
                                showImageOverlay.toggle()
                            }
                    }
                    
                    HStack {
                        Button(action: {
                            deletePhoto()
                        }) {
                            Text("Delete")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            keepPhoto()
                        }) {
                            Text("Keep")
                                .padding()
                                .background(Color.blue)
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
            
            if showImageOverlay, let image = selectedImage {
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showImageOverlay.toggle()
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
        
        photos = fetchedPhotos.shuffled()
        refreshPhoto()
        if !photos.isEmpty {
            photoCell = PhotoCell(asset: photos[currentIndex], onDelete: {
                                                                    photos.remove(at: currentIndex)
                                                                    refreshPhoto()
                                                                }, onKeep: {
                                                                    photos.remove(at: currentIndex)
                                                                    refreshPhoto()
                                                                })

        }
    }
    
    private func refreshPhoto() {
        if !photos.isEmpty {
            currentIndex = Int.random(in: 0..<photos.count)
            guard var cell = photoCell else { return }
            cell.asset = photos[currentIndex]
            photoCell = cell

        }
    }
    
    private func loadImageForOverlay() {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        imageManager.requestImage(for: photos[currentIndex], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { (result, _) in
            if let result = result {
                selectedImage = result
            }
        }
    }
    private func deletePhoto() {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets([photos[currentIndex]] as NSArray)
            }) { success, error in
                if success {
                    print("Deleted photo: \(photos[currentIndex].localIdentifier)")
                    photos.remove(at: currentIndex)
                    refreshPhoto()
                } else if let error = error {
                    print("Error deleting photo: \(error.localizedDescription)")
                }
            }
        }
        
        private func keepPhoto() {
            print("Kept photo: \(photos[currentIndex].localIdentifier)")
            photos.remove(at: currentIndex)
            refreshPhoto()
        }
}
