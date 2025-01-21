//
//  DuplicateFinder 2.swift
//  SmartPhotoOrganizerApp
//
//  Created by Pranav Pratap Singh on 1/21/25.
//


import UIKit
import Photos

class DuplicateFinder {
    static func findDuplicates(photos: [PHAsset]) -> [PHAsset] {
        var hashes = [String: PHAsset]()
        var duplicates = [PHAsset]()
        
        for photo in photos {
            let image = getImageFromAsset(asset: photo)
            let hash = perceptualHash(image: image)
            
            if let existingPhoto = hashes[hash] {
                duplicates.append(existingPhoto)
                duplicates.append(photo)
            } else {
                hashes[hash] = photo
            }
        }
        
        return Array(Set(duplicates)) // Remove duplicates from the duplicates array
    }
    
    private static func getImageFromAsset(asset: PHAsset) -> UIImage? {
        let imageManager = PHImageManager.default()
        var image: UIImage?
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: options) { (result, _) in
            image = result
        }
        
        return image
    }
    
    private static func perceptualHash(image: UIImage?) -> String {
        guard let image = image else { return "" }
        
        // Convert image to grayscale and resize
        let resizedImage = image.resized(to: CGSize(width: 8, height: 8))?.grayscale()
        
        // Generate hash from the pixel values
        var hash = ""
        if let pixelData = resizedImage?.cgImage?.dataProvider?.data {
            let data = CFDataGetBytePtr(pixelData)
            for x in 0..<8 {
                for y in 0..<8 {
                    let pixelIndex = (y * 8 + x) * 4
                    let brightness = (data![pixelIndex] + data![pixelIndex + 1] + data![pixelIndex + 2]) / 3
                    hash += brightness < 128 ? "0" : "1"
                }
            }
        }
        
        return hash
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func grayscale() -> UIImage? {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectMono")
        currentFilter?.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter?.outputImage, let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}
