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
    var exportedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIElements()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // UITextViewDelegate Methods
    func textViewDidChange(textView: UITextView) {
        if textView.restorationIdentifier == "headlineTextView" {
            headlineOverlayLabel.text = headlineTextView.text
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
    // -- UITextViewDelegate Methods
    func initUIElements() {
        headlineTextView.delegate = self
        tweetBodyTextView.delegate = self
        headlineOverlayLabel.text = "Make your message beautiful, simply type."
        headlineTextView.text = headlineTextViewPlaceholder
        tweetBodyTextView.text = tweetBodyTextViewPlaceholder
        tweetImageView.addSubview(headlineOverlayLabel)
        tweetImageView.userInteractionEnabled = true
        headlineOverlayLabel.userInteractionEnabled = true
//        tweetImageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    // http://www.theappguruz.com/tutorial/ios-text-overlay-image/
//    func initPanGestureRecognizer() {
//        var panGesture = UIPanGestureRecognizer(target: <#AnyObject#>, action: <#Selector#>)
//    }
    
    func exportImage() {
        UIGraphicsBeginImageContext(tweetImageView.bounds.size)
        var context: CGContextRef = UIGraphicsGetCurrentContext()
        tweetImageView.layer.renderInContext(context)
        exportedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    @IBAction func twitterSignInPressed(sender: UIButton) {
        exportImage()
        var shareOnTwitter: SLComposeViewController =
            SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareOnTwitter.setInitialText(tweetBodyTextView.text)
        shareOnTwitter.addImage(exportedImage)
        presentViewController(shareOnTwitter, animated: true, completion: nil)
    }
}