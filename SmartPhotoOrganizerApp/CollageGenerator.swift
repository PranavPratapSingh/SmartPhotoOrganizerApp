//
//  CollageGenerator.swift
//  SmartPhotoOrganizerApp
//
//  Created by Pranav Pratap Singh on 1/21/25.
//

import UIKit

class CollageGenerator {
    static func createCollage(images: [UIImage]) -> UIImage? {
        // Create a new image context
        let collageSize = CGSize(width: 800, height: 800) // Example size
        UIGraphicsBeginImageContext(collageSize)
        
        for (index, image) in images.enumerated() {
            let x = (index % 2) * 400
            let y = (index / 2) * 400
            image.draw(in: CGRect(x: x, y: y, width: 400, height: 400))
        }
        
        let collageImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return collageImage
    }
}
