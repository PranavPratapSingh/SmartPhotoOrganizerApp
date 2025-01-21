
import Photos

class PhotoManager {
    static let shared = PhotoManager()
    
    func fetchPhotos() -> [PHAsset] {
        var assets: [PHAsset] = []
        let fetchOptions = PHFetchOptions()
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        allPhotos.enumerateObjects { (asset, _, _) in
            assets.append(asset)
        }
        return assets
    }
}
