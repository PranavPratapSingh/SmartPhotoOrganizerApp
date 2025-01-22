import SwiftUI
import Photos

struct CollageView: View {
    var selectedPhotos: [PHAsset]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Collage")
                    .font(.largeTitle)
                    .padding()
                
                // Create a grid layout for the collage
                let columns = Array(repeating: GridItem(.flexible()), count: min(selectedPhotos.count, 5))
                LazyVGrid(columns: columns) {
                    ForEach(selectedPhotos, id: \.self) { asset in
                        ImageView(asset: asset)
                            .frame(height: 100) // Set a fixed height for the collage images
                    }
                }
                .padding()
            }
        }
    }
}

struct ImageView: View {
    var asset: PHAsset
    @State private var uiImage: UIImage? = nil
    
    var body: some View {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { (result, _) in
            uiImage = result
        }
        
        return Image(uiImage: uiImage ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
    }
}
