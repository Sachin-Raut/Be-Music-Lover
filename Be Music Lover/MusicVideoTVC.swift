//
//  MusicVideoTVC.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 14/05/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import UIKit
class MusicVideoTVC: UITableViewController
{
    
    var limit = 10

    var videos = [Videos]()
    
    var filterSearch = [Videos]()
    
    
    
    //if you want to display search result in same then use "nil"
    
    let resultSearchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MusicVideoTVC.reachabilityStatusChanged), name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        
        reachabilityStatusChanged()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let manager = CoreDataManager()
        
        let songs = manager.fetchSongList()
        
        for song in songs
        {
            songID.append(song.songID!)
        }
        //reachabilityStatusChanged()
    }
    
        
    func runAPI()
    {
        getAPICount()
        
        //call api
        
        let api = APIManager()
        
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json")
            {                
                result in
                
                //print(reachabilityStatus)
                
                self.videos = result
                
//                for (index, item) in self.videos.enumerated()
//                {
//                    print("\(index) - \(item.songID)")
//                    
//                }
                
                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
                
                self.navigationController?.navigationBar.backgroundColor = UIColor.black
                
                self.title = ("The iTunes Top \(self.limit) Music Videos")
                
                
                //set up the search controller
                
                /*
                
                Make sure that the search bar doesn't remain on the screen if the user navigate to another view
                
                */
                
                self.resultSearchController.searchResultsUpdater = self
                
                self.definesPresentationContext = true
                
                self.resultSearchController.dimsBackgroundDuringPresentation = false
                
                self.resultSearchController.searchBar.placeholder = "Search for Artist, Video or Rank"
                
                self.resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
                
                //add searchbar to tableview
                
                self.tableView.tableHeaderView = self.resultSearchController.searchBar
                
                self.tableView.reloadData()
                
        }
        
    }
    
    
    func getAPICount()
    {
        if (UserDefaults.standard.object(forKey: "APICount") != nil)
        {
            let theValue = UserDefaults.standard.object(forKey: "APICount") as! Int
            
            limit = theValue
        }
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        
        let refreshDate = formatter.string(from: Date())
        
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDate)")
    }
    
    
    
    func filterSearch(_ searchText: String)
    {
        filterSearch = videos.filter({ (videos) -> Bool in
            
            return videos.vArtist.lowercased().contains(searchText.lowercased())
            || videos.vName.lowercased().contains(searchText.lowercased())
            || "\(videos.vRank)".lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl)
    {
        
        //as soon as we pull down, we want spinner to stop
        refreshControl?.endRefreshing()
        
        if resultSearchController.isActive
        {
            refreshControl?.attributedTitle = NSAttributedString(string: "No refresh allowed in search")
        }
        else
        {
            runAPI()
        }
    }
    
//    @IBAction func refresh(sender: UIRefreshControl)
//    {
//        //as soon as we pull down, we want spinner to stop
//        
//        refreshControl?.endRefreshing()
//        
//        runAPI()
//    }
//    
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if resultSearchController.isActive
        {
            return filterSearch.count
        }
        
        return videos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MusicVideoTableViewCell
        
        if resultSearchController.isActive
        {
            cell.video = filterSearch[indexPath.row]
        }
        else
        {
            cell.video = videos[indexPath.row]
        }
        
        
        return cell
    }
    
    
    func reachabilityStatusChanged()
    {
        //print("Hi")
        
        switch reachabilityStatus
        {
        case NOACCESS :
            //view.backgroundColor = UIColor.redColor()
           
            //move back to main queue
            
            DispatchQueue.main.async
            {
            
            let alert = UIAlertController(title: "No internet access", message: "Please check net connection", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            {
                action -> () in
                print("Cancel")
            }
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive)
            {
                action -> () in
                print("Delete")
            }
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            {
                action -> () in
                print("OK")
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true, completion: nil)
           
            }
            
        default :
            
            //view.backgroundColor = UIColor.greenColor()
            
            if videos.count > 0
            {
                //we already have data
                print("Don't refresh API")
            }
            else
            {
                runAPI()
            }
        }
    }
    
    //remove observer
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "musicDetail"
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                
                let video: Videos
                
                if resultSearchController.isActive
                {
                    video = filterSearch[indexPath.row]
                }
                else
                {
                    video = videos[indexPath.row]
                }
                
                let dvc = segue.destination as! MusicVideoDetailVC
                
                dvc.videos = video
            }
        }
    }
}


extension MusicVideoTVC: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        searchController.searchBar.text?.lowercased()
        
        filterSearch(searchController.searchBar.text!)
    }
}





