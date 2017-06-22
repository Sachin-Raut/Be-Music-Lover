//
//  FavouriteSongDataManager.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 10/06/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import UIKit

class FavouriteSongDataManager: NSObject
{
    var songs = [FavouriteSong]()
    
    let manager = CoreDataManager()
    
    func fetchSongs()
    {
        for data in manager.fetchSongList()
        {
            songs.append(data)
        }
    }
    
    func numberOfItems() -> Int
    {
        return songs.count
    }
    
    func song(at index: IndexPath) -> FavouriteSong
    {
        return songs[index.row]
    }
    
}
