//
//  ImageSearchService.swift
//  Spruce
//
//  Created by Feifan Wang on 1/26/15.
//  Copyright (c) 2015 Fei. All rights reserved.
//

import Foundation

class ImageSearchService {
    func getImageSearches(callback: ([NSDictionary]) -> ()) {
        request("http://localhost:3000/api/images?term=corgi", callback: callback)
    }
    
    func request(url: String, callback: ([NSDictionary]) -> ()) {
        var nsURL = NSURL(string: url)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(nsURL) {
            (data, res, error) in
            var error: NSError?
            // &error means a reference to the error
            // re-encode the json into an object
            var response = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as [NSDictionary]
            callback(response)
        }
        task.resume()
    }
}