//
//  ViewController.swift
//  Spruce
//
//  Created by Feifan Wang on 1/20/15.
//  Copyright (c) 2015 Fei. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var tweetBodyTextView: UITextView!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var headlineOverlayLabel: UILabel!
    @IBOutlet weak var headlineTextView: UITextView!
    
    let headlineTextViewPlaceholder: String = "Type the message you want over the photo here"
    let tweetBodyTextViewPlaceholder: String = "Type your tweet here"
    override func viewDidLoad() {
        super.viewDidLoad()
        headlineTextView.delegate = self
        tweetBodyTextView.delegate = self
        headlineOverlayLabel.text = "Make your message beautiful, simply type."
        headlineTextView.text = headlineTextViewPlaceholder
        tweetBodyTextView.text = tweetBodyTextViewPlaceholder
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // UITextViewDelegate Methods
    func textViewDidChange(textView: UITextView) {
        if textView.restorationIdentifier == "headlineTextView" {
            headlineOverlayLabel.text = headlineTextView.text
        } else if textView.restorationIdentifier == "tweetBodyTextView" {
            println("tweet body")
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.restorationIdentifier == "headlineTextView"
        && textView.text == headlineTextViewPlaceholder {
            textView.text = ""
        } else if textView.restorationIdentifier == "tweetBodyTextView"
            && textView.text == tweetBodyTextViewPlaceholder
        {
            textView.text = ""
        }
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if textView.restorationIdentifier == "headlineTextView"
            && textView.text == ""
        {
            textView.text = headlineTextViewPlaceholder
        } else if textView.restorationIdentifier == "tweetBodyTextView"
            && textView.text == ""
        {
            textView.text = tweetBodyTextViewPlaceholder
        }
        return true
    }
    
    @IBAction func twitterSignInPressed(sender: UIButton) {
        var shareOnTwitter: SLComposeViewController =
            SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareOnTwitter.setInitialText(tweetBodyTextView.text)
        shareOnTwitter.addImage(tweetImageView.image)
        presentViewController(shareOnTwitter, animated: true, completion: nil)
    }
}