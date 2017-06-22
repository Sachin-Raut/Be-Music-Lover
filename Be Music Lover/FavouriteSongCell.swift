//
//  FavouriteSongCell.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 11/06/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import UIKit


class FavouriteSongCell: UITableViewCell
{
    
    
    @IBOutlet weak var videoName: UILabel!
    
    @IBOutlet weak var artist: UILabel!

    
    @IBAction func playButtonTapped(_ sender: Any)
    {
        
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
