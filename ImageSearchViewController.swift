//
//  ImageSearchViewController.swift
//  Spruce
//
//  Created by Feifan Wang on 1/26/15.
//  Copyright (c) 2015 Fei. All rights reserved.
//

import UIKit

class ImageSearchViewController: UIViewController,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegate {
    @IBOutlet weak var imageResultsCollectionView: UICollectionView!
    @IBOutlet weak var imageSearchTextField: UITextField!
    
    var mainVC: ViewController!
    var searchResults: [UIImage!] = []
    var imageSearchService: ImageSearchService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageResultsCollectionView.hidden = true
        imageSearchService = ImageSearchService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchImages(callback: (UIImage) -> ()) {
        var resultImages = [UIImage]()
        let searchTerm = imageSearchTextField.text
        imageSearchService.getImageSearches(searchTerm:searchTerm) {
            (images) in
            for image in images {
                let imageURL = NSURL(string: image["url"]! as String)!
                let imageData = NSData(contentsOfURL: imageURL)!
                let image = UIImage(data: imageData)!
                callback(image)
            }
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageSearchResultCell", forIndexPath: indexPath) as ImageSearchResultCell
        cell.resultImageView.image = searchResults[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        mainVC.originalImage = searchResults[indexPath.row]
        mainVC.tweetImageView.image = searchResults[indexPath.row]
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchBtnTapped(sender: AnyObject) {
        imageResultsCollectionView.hidden = false
        fetchImages() {
            (downloadedImage) in
            self.searchResults.append(downloadedImage)
            dispatch_async(dispatch_get_main_queue()) {
                self.imageResultsCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func backBtnTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}