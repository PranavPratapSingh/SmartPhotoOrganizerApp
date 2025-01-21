//
//  PhotoFilters.swift
//  SmartPhotoOrganizerApp
//
//  Created by Pranav Pratap Singh on 1/21/25.
//

import UIKit
import CoreImage

class PhotoFilters {
    static func applyFilter(to image: UIImage, filterName: String) -> UIImage? {
        let ciImage = CIImage(image: image)
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let outputImage = filter?.outputImage {
            return UIImage(ciImage: outputImage)
        }
        return nil
    }
}
