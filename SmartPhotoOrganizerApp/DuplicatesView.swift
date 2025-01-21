//
//  DuplicatesView.swift
//  SmartPhotoOrganizerApp
//
//  Created by Pranav Pratap Singh on 1/21/25.
//


import SwiftUI
import Photos

struct DuplicatesView: View {
    var duplicates: [PHAsset]
    
    @State private var images: [UIImage] = []
    
    var body: some View {
        List {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }
        }
        .navigationTitle("Duplicates Found")
        .onAppear {
            loadImages()
        }
    }
    
    private func loadImages() {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        for asset in duplicates {
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) { (result, _) in
                if let result = result {
                    images.append(result)
                }
            }
        }
    }
}