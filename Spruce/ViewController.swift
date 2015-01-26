//
//  ViewController.swift
//  Spruce
//
//  Created by Feifan Wang on 1/20/15.
//  Copyright (c) 2015 Fei. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ViewController: UIViewController,
                      UITextViewDelegate,
                      UICollectionViewDataSource,
                      UICollectionViewDelegate,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {
    @IBOutlet weak var tweetBodyTextView: UITextView!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var headlineOverlayLabel: UILabel!
    @IBOutlet weak var headlineTextView: UITextView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let headlineTextViewPlaceholder: String = "Type the message you want over the photo here"
    let tweetBodyTextViewPlaceholder: String = "Type your tweet here"
    var defaultImages: [UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIElements()
        populateDefaultImages()
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
    
    // UICollectionViewDataSource, UICollectionViewDelegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    // --UICollectionViewDataSource, UICollectionViewDelegate
    
    // UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        tweetImageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    // --UIImagePickerControllerDelegate
    
    func populateDefaultImages() {
        let url = NSURL(string: "https://farm4.staticflickr.com/3251/3089268872_1869860fbf_t.jpg")
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)!
        defaultImages = [image, image, image, image, image, image]
    }
    
    // http://www.theappguruz.com/tutorial/ios-text-overlay-image/
//    func initPanGestureRecognizer() {
//        var panGesture = UIPanGestureRecognizer(target: <#AnyObject#>, action: <#Selector#>)
//    }
    
    func exportImage() -> UIImage {
        UIGraphicsBeginImageContext(tweetImageView.bounds.size)
        var context: CGContextRef = UIGraphicsGetCurrentContext()
        tweetImageView.layer.renderInContext(context)
        let exportedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return exportedImage
    }
    
    @IBAction func saveImageTapped(sender: AnyObject) {
        let exportedImage = exportImage()
        UIImageWriteToSavedPhotosAlbum(exportedImage, nil, nil, nil)
        presentAlert(title: "Success!", message: "Image successfully saved to your library!")
    }
    
    @IBAction func cameraBtnTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            var cameraCtr = UIImagePickerController()
            cameraCtr.delegate = self
            cameraCtr.sourceType = UIImagePickerControllerSourceType.Camera
            cameraCtr.mediaTypes = [kUTTypeImage]
            cameraCtr.allowsEditing = true
            presentViewController(cameraCtr, animated: true, completion: nil)
        } else { presentAlert(message: "No camera available") }
    }
    
    @IBAction func addFilterBtnTapped(sender: AnyObject) {
        var filterVC = FilterViewController()
        filterVC.canvasImage = tweetImageView.image
        filterVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        presentViewController(filterVC, animated: true, completion: nil)
    }
    
    @IBAction func importFromPhotoLibBtnTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            var photoLibCtr = UIImagePickerController()
            photoLibCtr.delegate = self
            photoLibCtr.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            photoLibCtr.mediaTypes = [kUTTypeImage]
            photoLibCtr.allowsEditing = true
            presentViewController(photoLibCtr, animated: true, completion: nil)
        } else { presentAlert(message: "No photo lib available") }
    }
    
    @IBAction func twitterSignInPressed(sender: UIButton) {
        let exportedImage = exportImage()
        var shareOnTwitter: SLComposeViewController =
            SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareOnTwitter.setInitialText(tweetBodyTextView.text)
        shareOnTwitter.addImage(exportedImage)
        presentViewController(shareOnTwitter, animated: true, completion: nil)
    }
    
    // Utilities
    
    func presentAlert(title: String = "Alert", message: String) {
        var alertCtr = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertCtr.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertCtr, animated: true, completion: nil)
    }
}