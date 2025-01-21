import SwiftUI
import Photos

struct PhotoCell: View {
    var asset: PHAsset
    var onDelete: () -> Void // Closure to call when deleting
    var onKeep: () -> Void // Closure to call when keeping
    
    @State private var image: UIImage?
    @State private var showMetadata: Bool = false
    @State private var offset: CGSize = .zero // Track the drag offset
    
    var body: some View {
        LazyVStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .offset(x: offset.width) // Apply the drag offset
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation // Update offset during drag
                            }
                            .onEnded { gesture in
                                if gesture.translation.width < -100 {
                                    deletePhoto() // Swipe left to delete
                                } else if gesture.translation.width > 100 {
                                    keepPhoto() // Swipe right to keep
                                }
                                offset = .zero // Reset offset after swipe
                            }
                    )
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(maxWidth: .infinity, minHeight: 200)
            }
            Text(asset.localIdentifier)
                .lineLimit(1)
                .padding(.top, 5)
        }
        .onAppear {
            loadImage() // Load the image when the view appears
        }
        .onChange(of:asset) { _ in
            loadImage() // Reload the image when the asset changes
        }
        .onTapGesture {
            showMetadata.toggle()
        }
        .alert(isPresented: $showMetadata) {
            Alert(title: Text("Photo Metadata"),
                  message: Text(getMetadata()),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private func loadImage() {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { (result, _) in
            if let result = result {
                image = result
            }
        }
    }
    
    private func deletePhoto() {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
        }) { success, error in
            if success {
                print("Deleted photo: \(asset.localIdentifier)")
                onDelete() // Call the onDelete closure
            } else if let error = error {
                print("Error deleting photo: \(error.localizedDescription)")
            }
        }
    }
    
    private func keepPhoto() {
        print("Kept photo: \(asset.localIdentifier)")
        onKeep() // Call the onKeep closure
    }
    
    private func getMetadata() -> String {
        var metadata = "Local Identifier: \(asset.localIdentifier)\n"
        if let creationDate = asset.creationDate {
            metadata += "Creation Date: \(creationDate)\n"
        }
        if let location = asset.location {
            metadata += "Location: \(location.coordinate.latitude), \(location.coordinate.longitude)\n"
        }
        return metadata
    }
}
