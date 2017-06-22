//
//  iTunesWebview.swift
//  Be Music Lover
//
//  Created by Sachin Raut on 21/06/17.
//  Copyright © 2017 Sachin Raut. All rights reserved.
//

import UIKit

class iTunesWebviewVC: UIViewController
{
    var url: String? = nil
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let receivedURL = URL(string: url!)
        
        let urlRequest = URLRequest(url: receivedURL!)
        
        self.webView.loadRequest(urlRequest)
        
    }

}
