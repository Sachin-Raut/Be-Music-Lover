//
//  MusicVideo.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 13/05/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import Foundation

class Videos
{
    //data encapsulation
    
    //lets capture video name, video image & video url
    
    fileprivate var _vName: String
    fileprivate var _vImageURL: String
    fileprivate var _videoURL: String
    
    fileprivate var _trackLinkToiTunes: String
    
    fileprivate var _vRights: String
    fileprivate var _vPrice: String
    fileprivate var _vArtist: String
    fileprivate var _vIMID: String
    fileprivate var _vGenre: String
    fileprivate var _vLinkToiTunes: String
    fileprivate var _vReleaseDate: String
    fileprivate var _songID: String
    
    var vRank = 0
    
    //create a variable vImageData, this variable gets created from the UI
    var vImageData: Data?
    
    //make a getter
    
    var vName: String
    {
        return _vName
    }
    
    var vImageURL: String
    {
        return _vImageURL
    }
    
    var vVideoURL: String
    {
        return _videoURL
    }
    
    var trackLinkToiTunes: String
    {
        return _trackLinkToiTunes
    }
    
    
    var vRights: String
    {
        return _vRights
    }
    
    var vPrice: String
    {
        return _vPrice
    }
    
    var vArtist: String
    {
        return _vArtist
    }
    
    var vIMID: String
    {
        return _vIMID
    }
    
    var vGenre: String
    {
        return _vGenre
    }
    
    var vLinkToiTunes: String
    {
        return _vLinkToiTunes
    }
    
    var vReleaseDate: String
    {
        return _vReleaseDate
    }
    
    var songID: String
    {
        return _songID
    }
    
    //custom initializer
    
    init(data: JSONDictionary)
    {
        //song ID
        if let id = data["id"] as? JSONDictionary, let attribute = id["attributes"] as? JSONDictionary, let songID = attribute["im:id"] as? String
        {
            self._songID = songID
        }
        else
        {
            self._songID = ""
        }
        
        //video name
        if let name = data["im:name"] as? JSONDictionary,let vName = name["label"] as? String
        {
            self._vName = vName
        }
        else
        {
            self._vName = ""
        }
        
        //video image
        if let img = data["im:image"] as? JSONArray, let image = img[2] as? JSONDictionary, let immage = image["label"] as? String
        {
            
            let bestImage = UserDefaults.standard.bool(forKey: "bestImage")
            
            if imageResolution == "600" && bestImage
            {
                _vImageURL = immage.replacingOccurrences(of: "100x100", with: "600x600")
            }
            else if imageResolution == "600" && !bestImage
            {
                _vImageURL = immage.replacingOccurrences(of: "100x100", with: "300x300")
            }
            else if imageResolution == "450" && bestImage
            {
                _vImageURL = immage.replacingOccurrences(of: "100x100", with: "450x450")
            }
            else
            {
                _vImageURL = immage.replacingOccurrences(of: "100x100", with: "50x50")
            }
        }
        else
        {
            _vImageURL = ""
        }
        
        //video url
        if let video = data["link"] as? JSONArray, let vURL = video[1] as? JSONDictionary, let vHref = vURL["attributes"] as? JSONDictionary, let vVideoURL = vHref["href"] as? String
        {
            self._videoURL = vVideoURL
        }
        else
        {
            self._videoURL = ""
        }
        
        
        //trackLinkToiTunes
        if let video = data["link"] as? JSONArray, let vURL = video[0] as? JSONDictionary, let vHref = vURL["attributes"] as? JSONDictionary, let vVideoURL = vHref["href"] as? String
        {
            self._trackLinkToiTunes = vVideoURL.replacingOccurrences(of: "uo=2", with: "ign-mpt=uo%3D2")
        }
        else
        {
            self._trackLinkToiTunes = ""
        }
        
        
        //video rights
        if let videoRights = data["rights"] as? JSONDictionary, let rights = videoRights["label"] as? String
        {
            self._vRights = rights
        }
        else
        {
            self._vRights = ""
        }
        
        //video price
        if let videoPrice = data["im:price"] as? JSONDictionary, let vP = videoPrice["label"] as? String
        {
            self._vPrice = vP
        }
        else
        {
            self._vPrice = ""
        }
        
        //video artist
        if let videoArtist = data["im:artist"] as? JSONDictionary, let vA = videoArtist["label"] as? String
        {
            self._vArtist = vA
        }
        else
        {
            self._vArtist = ""
        }
        
        //video genre
        if let category = data["category"] as? JSONDictionary, let attributes = category["attributes"] as? JSONDictionary, let genre = attributes["term"] as? String
        {
            self._vGenre = genre
        }
        else
        {
            self._vGenre = ""
        }
        
        //artist id (imid)
        if let imid = data["id"] as? JSONDictionary, let vid = imid["attributes"] as? JSONDictionary, let vIMID = vid["im:id"] as? String
        {
            self._vIMID = vIMID
        }
        else
        {
            self._vIMID = ""
        }
        
        //video release date
        if let releaseDate = data["im:releaseDate"] as? JSONDictionary, let attributes = releaseDate["attributes"] as? JSONDictionary, let label = attributes["label"] as? String
        {
            self._vReleaseDate = label
        }
        else
        {
            self._vReleaseDate = ""
        }
        
        //link to iTunes
        if let release = data["id"] as? JSONDictionary, let videoLink = release["label"] as? String
        {
            self._vLinkToiTunes = videoLink
        }
        else
        {
            self._vLinkToiTunes = ""
        }
        
    }
}
