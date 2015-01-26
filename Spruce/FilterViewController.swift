//
//  FilterViewController.swift
//  Spruce
//
//  Created by Feifan Wang on 1/24/15.
//  Copyright (c) 2015 Fei. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var canvasImage: UIImage!
    var collectionView: UICollectionView!
    var backBtn: UIButton!
    
    let kIntensity = 0.7
    let placeholderImage = UIImage(named: "Placeholder")
    var filters: [CIFilter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        view.addSubview(collectionView)
        setupUI()
        filters = imageFilters()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: FilterCell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterCell", forIndexPath: indexPath) as FilterCell
        
        // prevent the block from re-running if the image has already been filered
        if cell.imageView.image == nil {
            cell.imageView.image = placeholderImage
            let filterQueue: dispatch_queue_t = dispatch_queue_create("FilterQueue", nil)
            
            dispatch_async(filterQueue) { () -> Void in
                let filteredImage = self.applyImageFilter(self.canvasImage, filter: self.filters[indexPath.row])
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.imageView.image = filteredImage
                })
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    // IBAction
    func backBtnTapped(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Utilities
    func setupUI() {
        backBtn = UIButton()
        backBtn.setTitle("Back", forState: UIControlState.Normal)
        backBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        backBtn.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        backBtn.backgroundColor = UIColor.whiteColor()
        backBtn.sizeToFit()
        backBtn.center = CGPoint(x: view.frame.width / 8.0, y: 50)
        backBtn.addTarget(self, action: "backBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(backBtn)
    }
    
    func imageFilters() -> [CIFilter] {
        let blur = CIFilter(name: "CIGaussianBlur")
        let instant = CIFilter(name: "CIPhotoEffectInstant")
        let noir = CIFilter(name: "CIPhotoEffectNoir")
        let transfer = CIFilter(name: "CIPhotoEffectTransfer")
        let unsharpen = CIFilter(name: "CIUnsharpMask")
        let monochrome = CIFilter(name: "CIColorMonochrome")
        
        let colorControls = CIFilter(name: "CIColorControls")
        colorControls.setValue(0.5, forKey: kCIInputSaturationKey) // change the saturation of this filter
        
        let sepia = CIFilter(name: "CISepiaTone")
        sepia.setValue(kIntensity, forKey: kCIInputIntensityKey)
        
        let colorClamp = CIFilter(name: "CIColorClamp")
        colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
        colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
        
        let composite = CIFilter(name: "CIHardLightBlendMode")
        composite.setValue(sepia.outputImage, forKey: kCIInputImageKey) // kCIInputImageKey inputs the image from the sepia output
        let vignette = CIFilter(name: "CIVignette")
        vignette.setValue(composite.outputImage, forKey: kCIInputImageKey)
        vignette.setValue(kIntensity * 2, forKey: kCIInputIntensityKey)
        vignette.setValue(kIntensity * 30, forKey: kCIInputRadiusKey)
        
        return [blur, instant, noir, transfer, unsharpen, monochrome, colorControls, colorClamp, sepia, vignette]
    }
    
    func applyImageFilter(image: UIImage, filter: CIFilter) -> UIImage {
        let imageData = UIImageJPEGRepresentation(image, 0.1) // low quality thumbnail
        let originalImage = CIImage(data: imageData)
        filter.setValue(originalImage, forKey: kCIInputImageKey)
        
        // optimize image size
        let context = CIContext(options: nil)
        let filteredImage: CIImage = filter.outputImage
        let cgImage: CGImageRef = context.createCGImage(filteredImage, fromRect: filteredImage.extent())
        return UIImage(CGImage: cgImage, scale: 1.0, orientation: UIImageOrientation.Up)!
    }
}


































