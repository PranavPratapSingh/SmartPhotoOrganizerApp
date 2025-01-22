import SwiftUI
import Photos

struct PhotoCellCollage: View {
    var asset: PHAsset
    var onSelect: () -> Void // Closure to handle selection
    var selected: Bool // Indicates if the photo is selected

    @State private var uiImage: UIImage? = nil

    var body: some View {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { (result, _) in
            uiImage = result
        }
        
        return Button(action: {
            onSelect() // Call the selection handler when tapped
        }) {
            ZStack {
                Image(uiImage: uiImage ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .cornerRadius(8)
                
                // Add a border to indicate selection
                Rectangle()
                    .stroke(selected ? Color.blue : Color.clear, lineWidth: 4)
                    .cornerRadius(8)
            }
        }
    }
}
