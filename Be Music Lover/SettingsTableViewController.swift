//
//  SettingsTableViewController.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 15/05/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate
{
    @IBOutlet weak var touchID: UISwitch!
    
    @IBOutlet weak var bestImageSwitch: UISwitch!
    
    
    @IBOutlet weak var imageInfoLabel: UILabel!
    
    @IBOutlet weak var APICount: UILabel!
    
    @IBOutlet weak var sliderCount: UISlider!
    
    @IBAction func touchIDSwitchPressed(_ sender: AnyObject)
    {
        let defaults = UserDefaults.standard
        
        if touchID.isOn
        {
            defaults.set(touchID.isOn, forKey: "securitySetting")
        }
        else
        {
            defaults.set(false, forKey: "securitySetting")
        }
    }
    
   
    
    @IBAction func bestImageSwitchPresssed(_ sender: AnyObject)
    {
        let defaults = UserDefaults.standard
        
        if bestImageSwitch.isOn
        {
            defaults.set(bestImageSwitch.isOn, forKey: "bestImage")
            if imageResolution == "600"
            {
                imageInfoLabel.text = "WiFi with best image, res.600x600"
            }
            if imageResolution == "450"
            {
                imageInfoLabel.text = "Mobile Data with best image, res.450x450"
            }
            
        }
        else
        {
            defaults.set(false, forKey: "bestImage")
            if imageResolution == "600"
            {
                imageInfoLabel.text = "WiFi without best image, res.300x300"
            }
            if imageResolution == "450"
            {
                imageInfoLabel.text = "Mobile Data without best image, res.50x50"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let bestImage = UserDefaults.standard.bool(forKey: "bestImage")
        
        if bestImage && imageResolution == "600"
        {
            imageInfoLabel.text = "WiFi with best image, res.600x600"
        }
        else if !bestImage && imageResolution == "600"
        {
            imageInfoLabel.text = "WiFi without best image, res.300x300"
        }
        else if bestImage && imageResolution == "450"
        {
            imageInfoLabel.text = "Mobile Data with best image, res.450x450"
        }
        else
        {
            imageInfoLabel.text = "Mobile Data without best image, res.50x50"
        }
    }
    
    @IBAction func sliderDragged(_ sender: UISlider)
    {
        let defaults = UserDefaults.standard
        
        defaults.set(Int(sliderCount.value), forKey: "APICount")
        
        APICount.text = ("\(Int(sliderCount.value))")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()        
        
        title = "Settings"
        
        tableView.alwaysBounceVertical = false

        touchID.isOn = UserDefaults.standard.bool(forKey: "securitySetting")
        
        bestImageSwitch.isOn = UserDefaults.standard.bool(forKey: "bestImage")
        
        if UserDefaults.standard.object(forKey: "APICount") != nil
        {
            let theValue = UserDefaults.standard.object(forKey: "APICount") as! Int
            
            APICount.text = "\(theValue)"
            
            sliderCount.value = Float(theValue)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.section == 0 && indexPath.row == 0
        {
            
            tableView.deselectRow(at: indexPath, animated: true)
            //About row
            print("About")
        }
        
        if indexPath.section == 0 && indexPath.row == 1
        {
            //Feedback row
            
            let mailComposeViewController = configureMail()
            
            if MFMailComposeViewController.canSendMail()
            {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
            else
            {
                //no mail account setup on phone
                
                mailAlert()
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    
    func configureMail() -> MFMailComposeViewController
    {
        let mailComposeVC = MFMailComposeViewController()
        
        mailComposeVC.mailComposeDelegate = self
        
        mailComposeVC.setToRecipients(["bemusiclover@gmail.com"])
        
        mailComposeVC.setSubject("Be Music Lover app's feedback")
        
        mailComposeVC.setMessageBody("Hi Team Be Music Lover, \n\nI would like to share following feedback", isHTML: false)
        
        return mailComposeVC
    }
    
    func mailAlert()
    {
        let alert = UIAlertController(title: "Mail Alert", message: "No Email Account setup for this phone", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        switch result.rawValue
        {
        case MFMailComposeResult.cancelled.rawValue:
            print("mail cancelled")
            
        case MFMailComposeResult.saved.rawValue:
            print("mail saved")
            
        case MFMailComposeResult.sent.rawValue:
            print("mail sent")
            
        case MFMailComposeResult.failed.rawValue:
            print("mail failed")
            
        default:
            print("Unknown issue")
        }
        self.dismiss(animated: true, completion: nil)
    }

}
