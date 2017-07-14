//
//  APIManager.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 13/05/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import Foundation

var songID: [String]=[]

class APIManager
{
    func loadData(_ urlString: String, completion:@escaping ([Videos])-> Void)
    {
        //create singleton objects
        
        let session = URLSession.shared
        
        let url = URL(string: urlString)!
        
        //initiate task in background thread
        
        let task = session.dataTask(with: url, completionHandler:
        {
            (data, response, error)-> Void in
            
            //lets move it to the main thread
            
            DispatchQueue.main.async
            {
                if error != nil
                {
                    //completion(result: (error?.localizedDescription)!)
                    
                    print(error!.localizedDescription)
                }
                else
                {
                    //completion(result: "NSURLSession successful")
                    //print(data)
                    
                    //we are receiving NSData, convert it to JSON object & cast it to a Dictionary
                    do
                    {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? JSONDictionary, let feed = json["feed"] as? JSONDictionary, let entries = feed["entry"] as? JSONArray
                        {
                            //print(json)
                            
                            var videos = [Videos]()
                            
                            for (index, entry) in entries.enumerated()
                            {
                                let entry = Videos(data: entry as! JSONDictionary)
                                
                                entry.vRank = index + 1
                                
                                videos.append(entry)
                                
                            }
                            
                            //let i = videos.count
                            
                            //print("Total count \(i)")
                            
                            let priority = DispatchQueue.GlobalQueuePriority.high
                            
                            DispatchQueue.global(priority: priority).async
                            {
                                //move back to main thread
                                DispatchQueue.main.async
                                {
                                    completion(videos)
                                }
                            }
                        }
                    }
                    catch
                    {
                        print("error in NSJSONSerialization")
                    }
                }
            }
        })        

        task.resume()
    }
}
