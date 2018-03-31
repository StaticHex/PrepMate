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
        self.path = imageURL
        if(self.path == "") {
            return
        }
        let picURL = URL(string: self.path)
        let session = URLSession(configuration: .default)
        var pic : UIImage = UIImage()
        var finished : Bool = false
        let downloadTask = session.dataTask(with: picURL!) { (data, response, error) in
            if let _ = error {
                self.eMsg = "Something went wrong with the picture download!"
                finished = true
            } else {
                if let _ = response as? HTTPURLResponse {
                    if let iData = data {
                        pic = UIImage(data: iData)!
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
        while(!finished) {}
        self.image = pic
    }
}
