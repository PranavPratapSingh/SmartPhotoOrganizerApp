//
//  AlbumManager.swift
//  SmartPhotoOrganizerApp
//
//  Created by Pranav Pratap Singh on 1/21/25.
//


import Photos

class AlbumManager {
    static let shared = AlbumManager()
    
    func fetchAlbums() -> [PHAssetCollection] {
        var albums: [PHAssetCollection] = []
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        
        let allAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        allAlbums.enumerateObjects { (collection, _, _) in
            albums.append(collection)
        }
        
        return albums
    }
}