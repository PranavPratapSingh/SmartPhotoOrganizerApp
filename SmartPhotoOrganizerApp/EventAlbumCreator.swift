//
//  EventAlbumCreator.swift
//  SmartPhotoOrganizerApp
//
//  Created by Pranav Pratap Singh on 1/21/25.
//

import Photos

class EventAlbumCreator {
    static func createEventAlbums(photos: [PHAsset]) -> [String: [PHAsset]] {
        var eventAlbums = [String: [PHAsset]]()
        
        for photo in photos {
            if let creationDate = photo.creationDate {
                let dateString = DateFormatter.localizedString(from: creationDate, dateStyle: .medium, timeStyle: .none)
                eventAlbums[dateString, default: []].append(photo)
            }
        }
        return eventAlbums
    }
}
