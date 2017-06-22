//
//  MusicVideoDetailVC.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 15/05/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import LocalAuthentication


class MusicVideoDetailVC: UIViewController
{
    var videos: Videos!
    
    @IBOutlet weak var vName: UILabel!
    
    @IBOutlet weak var videoImage: UIImageView!
    
    @IBOutlet weak var vPrice: UILabel!
    
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var vGenre: UILabel!
    
    @IBOutlet weak var vRights: UILabel!
    
    var securitySwitch: Bool = false
    
    @IBOutlet weak var favouriteBarButton: UIBarButtonItem!
    
    @IBAction func favouriteButtonTapped(_ sender: UIBarButtonItem)
    {
        embedToolbar()
        
        //print(videos.songID)
        
        //add data to core data
        
        var song = FavouriteSong()
        
        song.songID = videos.songID
        song.artist = videos.vArtist
        song.videoName = videos.vName
        song.videoLink = videos.vVideoURL
        
        let manager = CoreDataManager()
        manager.addSong(song)
        
    }
    
    
    
    
    
    @IBAction func downloadiTunesButtonTapped(_ sender: Any)
    {
        //print("hi")
    }
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        if songID.contains(videos.songID)
        {
            embedToolbar()
        }
    }
    
    func embedToolbar()
    {
        
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(MusicVideoDetailVC.play))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(MusicVideoDetailVC.socialMediaPressed))
        )
        
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        )
        items.append(UIBarButtonItem(title: "Added", style: .plain, target: nil, action: nil))
 
        navigationController?.toolbar.tintColor = UIColor.red
        
        navigationController?.toolbar.items = items
        
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
        
        let url = URL(string: videos.vVideoURL)!
        
        let player = AVPlayer(url: url)
        
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        self.present(playerViewController, animated: true)
        {
            playerViewController.player?.play()
        }
    }
    
    @IBAction func playButtonPressed(_ sender: AnyObject)
    {
        play()
    }
    
    func socialMediaPressed()
    {
        securitySwitch = UserDefaults.standard.bool(forKey: "securitySetting")
        
        switch securitySwitch
        {
        case true:
            touchIDCheck()
            
        default:
            socialMedia()
        }
    }
    
    
    @IBAction func socialMediaButtonPressed(_ sender: AnyObject)
    {
        socialMediaPressed()
    }
    
    func touchIDCheck()
    {
        //create an alert
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
        
        //create local authentication context
        
        let context = LAContext()
        
        var touchIDError: NSError?
        
        let reasonString = "Touch ID authentication is needed to share info on social media"
        
        //check if we can access local device authentication (i.e check if touch id available)
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &touchIDError)
        {
            //check what the authentication response was
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: {
                (success, policyError) -> Void in
                
                if success
                {
                    //user authenticated using local device authentication successfully
                    
                    DispatchQueue.main.async
                    {
                        [unowned self] in
                        
                        self.socialMedia()
                    }
                }
                else
                {
                        alert.title = "Unsuccessful"
                        
                        switch LAError.Code(rawValue: policyError!._code)!
                        {
                        case .appCancel:
                            alert.message = "Authentication was cancelled by application"
                            
                        case .authenticationFailed:
                            alert.message = "The user failed to provide valid credentials"
                            
                        case .passcodeNotSet:
                            alert.message = "Passcode is not set on the device"
                            
                        case .systemCancel:
                            alert.message = "Authentication was cancelled by the system"
                            
                        case .touchIDLockout:
                            alert.message = "Too many failed attempts"
                            
                        case .userCancel:
                            alert.message = "You cancelled the request"
                            
                        case .userFallback:
                            alert.message = "Password not accepted, must use Touch ID"
                            
                        default:
                            alert.message = "Unable to authenticate"
                        }
                        
                        //show alert
                        
                        DispatchQueue.main.async{
                            [unowned self] in
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                
                
            })
        }
        else
        {
            //set the error title
                
            alert.title = "Error"
            
            //set the error alert message with more information
            
            switch LAError.Code(rawValue: touchIDError!.code)!
            {
            case .touchIDNotEnrolled:
                alert.message = "Touch ID is not enrolled"
                
            case .touchIDNotAvailable:
                alert.message = "Touch ID is not available on this device"
                
            case .passcodeNotSet:
                alert.message = "Passcode has not been set"
                
            case .invalidContext:
                alert.message = "The context is invalid"
                
            default:
                alert.message = "Local authentication not available"
            }
            
            //show the alert
            
            DispatchQueue.main.async
            {
                [unowned self] in
                self.present(alert, animated: true, completion: nil)
            }
        }
    }



    func socialMedia()
    {
        let activity1 = "Have you had the opportunity to see this music video?"
        
        let activity2 = ("\(videos.vName) by \(videos.vArtist)")
        
        let activity3 = "Watch it & tell me what you think?"
        
        let activity4 = videos.vLinkToiTunes
        
        let activity5 = "(Shared with BE MUSIC LOVER app)"
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [activity1, activity2, activity3, activity4, activity5], applicationActivities: nil)
        
        /* if you ant to exclude sharing on FB
        
        activityViewController.excludedActivityTypes = [UIActivityTypePostToFacebook]
        
        */
        
        activityViewController.completionWithItemsHandler =
        {
            (activity, success, items, error) in
            
            if activity == UIActivityType.mail
            {
                print("Mail selected")
            }
            
            
            if activity == UIActivityType.postToFacebook
            {
                print("Facebook selected")
            }
            
            
            if activity == UIActivityType.postToTwitter
            {
                print("Twitter selected")
            }
            
            if activity == UIActivityType.postToFlickr
            {
                print("Flickr selected")
            }
            
            if activity == UIActivityType.postToVimeo
            {
                print("Vimeo selected")
            }
            
            
        }
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        var passThisURL: String?
        
         if segue.identifier == "iTunesWebview"
         {
            passThisURL = videos.trackLinkToiTunes
         
            let dvc = segue.destination as! iTunesWebviewVC
         
            dvc.url = passThisURL
         
         }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //print(videos.trackLinkToiTunes)

        title = videos.vArtist
        
        vName.text = videos.vName + "\nSong preview provided courtesy of iTunes"
        
        vPrice.text = videos.vPrice
        //print(videos.vRights)
        vRights.text = videos.vRights
        
        vGenre.text = videos.vGenre
        
        if videos.vImageData != nil
        {
            videoImage.image = UIImage(data: videos.vImageData! as Data)
        }
        else
        {
            videoImage.image = UIImage(named: "image-not-available-250")
        }
        
    }    
}
