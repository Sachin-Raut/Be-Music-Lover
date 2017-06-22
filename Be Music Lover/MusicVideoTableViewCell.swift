//
//  MusicVideoTableViewCell.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 14/05/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell
{   
    @IBOutlet weak var musicImage: UIImageView!
    
    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var musicTitle: UILabel!
    
    
    @IBOutlet weak var favouriteImageView: UIImageView!
    
    
    
    var video: Videos?
    {
        didSet
        {
            updateCell()
        }
    }
    
    func updateCell()
    {
        musicTitle.text = video?.vName
        rank.text = ("\(video!.vRank)")
        if songID.contains((video?.songID)!)
        {
            favouriteImageView.isHidden = false
        }
        else
        {
            favouriteImageView.isHidden = true
        }
        if video?.vImageData != nil
        {
            //get imageData from array
            //print("Get image from array")
            musicImage.image = UIImage(data: (video?.vImageData)! as Data)
        }
        else
        {
            //get image in background thread
            //print("Get image in background thread")
            getVideoImage(video!, imageView: musicImage)
        }
    }
    
    func getVideoImage(_ video: Videos, imageView: UIImageView)
    {
        //fetch the image data from vImageURL in background thread
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
        {
            let data = try? Data(contentsOf: URL(string: video.vImageURL)!)
            
            var image: UIImage?
            
            if data != nil
            {
                video.vImageData = data! as NSData as Data
                
                image = UIImage(data: data!)
            }
            
            //move back to main queue
            
            DispatchQueue.main.async
            {
                imageView.image = image
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
