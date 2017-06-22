//
//  PlayFavouriteSongVC.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 11/06/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayFavouriteSongVC: UIViewController
{
    var favouriteURL: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        play()
    }
    
    
    func play()
    {
        /*
         
         if you set category to AVAudioSessionCategoryAmbient, and if the device is on silent mode then video will play without sound
         
         */
        
        let audioSession = AVAudioSession.sharedInstance()
        do
        {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: .duckOthers)
        }
        catch
        {
            print("AVAudioSession cannot be set")
        }
        
        
        let url = URL(string: favouriteURL)!
        let player = AVPlayer(url: url)
        
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        self.present(playerViewController, animated: true)
        {
            playerViewController.player?.play()
        }
    }
    

}
