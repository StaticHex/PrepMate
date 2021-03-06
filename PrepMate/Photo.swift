//
//  Photo.swift
//  PrepMate
//
//  Created by Joseph Bourque on 3/31/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//
import UIKit
import Foundation

class Photo {
    private var image : UIImage
    private var path : String
    private var eMsg : String
    
    init() {
        image = UIImage()
        path = ""
        eMsg = ""
    }
    
    public func copy(oldPhoto: Photo) {
        self.path = oldPhoto.getPath()
        self.image = oldPhoto.getImage()
    }
    
    //getters and setters
    public func getPath() -> String { return self.path }
    public func getImage() -> UIImage { return self.image }
    public func getEMsg() -> String { return self.eMsg }
    public func setPhoto( imageURL: String) {
        
        // set data based on passed URL
        self.path = imageURL
        self.eMsg = ""
        if(self.path == "") {
            self.image = #imageLiteral(resourceName: "2000px-Silver_-_replace_this_image_male.svg.png")
            return
        }
        
        let session = URLSession(configuration: .default)
        
        // clear cached response
        URLCache.shared.removeAllCachedResponses()
        var pic : UIImage = #imageLiteral(resourceName: "2000px-Silver_-_replace_this_image_male.svg.png")
        var finished : Bool = false
        if let picURL = URL(string: self.path) {
            let downloadTask = session.dataTask(with: picURL) { (data, response, error) in
                if let _ = error {
                    self.eMsg = "Something went wrong with the picture download!"
                    self.path = ""
                    finished = true
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let iData = data {
                            if let img = UIImage(data: iData) {
                                pic = img
                            } else {
                                pic = #imageLiteral(resourceName: "2000px-Silver_-_replace_this_image_male.svg.png")
                                self.path = ""
                                self.eMsg = "Image data corrupt or missing, check URL and try again."
                            }
                        } else {
                            self.eMsg = "Error, avatar image URL returned null or missing!"
                        }
                    } else {
                        self.eMsg = "Could not get image, failed to get a response from server!"
                    }
                    finished = true
                }
            }
            downloadTask.resume()
        } else {
            finished = true
            self.eMsg = "Image URL could not be resolved as a valid file!"
            self.path = ""
            pic = #imageLiteral(resourceName: "2000px-Silver_-_replace_this_image_male.svg.png")
        }

        while(!finished) {}
        self.image = pic
    }
}
