//
//  CoreDataManager.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 10/06/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject
{
    let container: NSPersistentContainer!
    
    override init()
    {
        container = NSPersistentContainer(name: "Songs")
        container.loadPersistentStores
        { (description, error) in
            guard error == nil
            else
            {
                return
            }
        }
        super.init()
    }
    
    
    func fetchSongList() -> [FavouriteSong]
    {
        let moc = container.viewContext
        let request: NSFetchRequest<Songs> = Songs.fetchRequest()
        
        request.returnsObjectsAsFaults = false
        
        //assign result to variable
        
        var favouriteSongs = [FavouriteSong]()
        
        do
        {
            for data in try moc.fetch(request)
            {
                favouriteSongs.append(FavouriteSong(data: data))
            }
        }
        catch
        {
            print(error)
        }
        return favouriteSongs
    }
    
    func addSong(_ song: FavouriteSong)
    {
        let newSong = Songs(context: container.viewContext)
        
        newSong.songID = song.songID
        newSong.artist = song.artist
        newSong.videoName = song.videoName
        newSong.videoLink = song.videoLink
        
        save()
    }
    
    func save()
    {
        do
        {
            if container.viewContext.hasChanges
            {
                try container.viewContext.save()
            }
        }
        catch let error
        {
            print(error.localizedDescription)
        }
    }
}
