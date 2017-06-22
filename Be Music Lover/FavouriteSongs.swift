//
//  FavouriteSongs.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 11/06/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import UIKit

class FavouriteSongs: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var favouriteSongs = [FavouriteSong]()
    
    override func viewDidLoad()
    {
        let manager = CoreDataManager()
        favouriteSongs = manager.fetchSongList()
        //print(favouriteSongs)
    }
 
}

extension FavouriteSongs: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return favouriteSongs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.rowHeight = 132
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavouriteSongCell
        
        cell.artist.text = "by " + "\(favouriteSongs[indexPath.row].artist!)"
        cell.videoName.text = favouriteSongs[indexPath.row].videoName
        //print(favouriteSongs[indexPath.row].videoLink!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //favouriteSongToPlayer
        if segue.identifier == "favouriteSongToPlayer"
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {   
                let pfs = segue.destination as! PlayFavouriteSongVC
                
                pfs.favouriteURL = favouriteSongs[indexPath.row].videoLink!
                
                //p = favouriteSongs[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)        
    }
}
