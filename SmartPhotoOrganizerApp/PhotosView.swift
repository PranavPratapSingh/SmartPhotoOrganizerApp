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
                            if currentIndex > 0 {
                                currentIndex -= 1
                                refreshPhoto()
                            }
                        }) {
                            Text("Previous")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(currentIndex == 0)
                        
                        Spacer()
                        
                        Button(action: {
                            if currentIndex < photos.count - 1 {
                                currentIndex += 1
                                refreshPhoto()
                            }
                        }) {
                            Text("Next")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(currentIndex == photos.count - 1)
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
}
