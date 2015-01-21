//
//  ViewController.swift
//  Spruce
//
//  Created by Feifan Wang on 1/20/15.
//  Copyright (c) 2015 Fei. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func twitterSignInPressed(sender: UIButton) {
        var shareOnTwitter: SLComposeViewController =
            SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareOnTwitter.setInitialText("TWEEEEET")
        shareOnTwitter.addImage(UIImage(named: "fei_img.jpg"))
        presentViewController(shareOnTwitter, animated: true, completion: nil)
    }
}