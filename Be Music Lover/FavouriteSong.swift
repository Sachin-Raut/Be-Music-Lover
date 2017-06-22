//
//  FavouriteSong.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 10/06/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import Foundation

struct FavouriteSong
{
    var songID: String?
    var artist: String?
    var videoName: String?
    var videoLink: String?
}

extension FavouriteSong
{
    init(data: Songs)
    {
        self.songID = data.songID
        self.artist = data.artist
        self.videoName = data.videoName
        self.videoLink = data.videoLink
    }
}
