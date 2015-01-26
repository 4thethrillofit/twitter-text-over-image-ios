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
    var mainVC: ViewController!
    var searchResults: [UIImage!] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageResultsCollectionView.hidden = true
        let image = UIImage(named: "Placeholder")
        searchResults = [image, image, image, image, image, image]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    
    @IBAction func backBtnTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}