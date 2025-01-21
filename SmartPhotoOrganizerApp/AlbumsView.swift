//
//  AlbumsView.swift
//  SmartPhotoOrganizerApp
//
//  Created by Pranav Pratap Singh on 1/21/25.
//


import SwiftUI
import Photos

struct AlbumsView: View {
    @State private var albums: [PHAssetCollection] = []
    
    var body: some View {
        if !albums.isEmpty{
            List(albums, id: \.self) { album in
                NavigationLink(destination: PhotosInAlbumView(album: album)) {
                    Text(album.localizedTitle ?? "Untitled Album")
                }
            }
            .navigationTitle("Albums")
            .onAppear {
                loadAlbums()
            }
        }else {
                    Text("No albums available.")
                        .font(.headline)
                        .padding()
                }
    }
    
    private func loadAlbums() {
        albums = AlbumManager.shared.fetchAlbums()
    }
}

struct PhotosInAlbumView: View {
    var album: PHAssetCollection
    
    @State private var photos: [PHAsset] = []
    
    var body: some View {
        List(photos, id: \.self) { photo in
            Text(photo.localIdentifier)
        }
        .navigationTitle(album.localizedTitle ?? "Photos")
        .onAppear {
            loadPhotos()
        }
    }
    
    private func loadPhotos() {
        let fetchOptions = PHFetchOptions()
        let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
        
        assets.enumerateObjects { (asset, _, _) in
            photos.append(asset)
        }
    }
}
