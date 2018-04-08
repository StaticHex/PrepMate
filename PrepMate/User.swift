//
//  User.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//
// TODO: Implement this
import UIKit
import Foundation
class User {
    private var id : Int
    private var uname : String
    private var pword : String
    private var photo : Photo
    private var fname : String
    private var lname : String
    private var email : String
    private var bio : String
    private var eMsg : String
    private var preferences : [(key: String, value: Int)]
    
    init() {
        id = -1
        uname = ""
        pword = ""
        photo = Photo()
        fname = ""
        lname = ""
        email = ""
        bio = ""
        eMsg = ""
        preferences = [(key: String, value: Int)]()
    }
    
    // Verify User Method
    // @param
    // - uname: User name to log in with
    // - pword: unencrpted password to check against database hash
    // @description
    // - Pings the REST API with the user's username and password
    //   and either displays an alert in the event of a mismatch or
    //   logs the user in and grabs all information from the database
    func verify(uname : String, pword: String) -> Bool {
        // pass in info to class variables in order to set up http request
        self.uname = uname
        self.pword = pword
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/VerifyUser.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let uname = self.uname
        let pword = self.pword
        
        let params = "uname="+uname+"&pword="+pword
        
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                self.eMsg = error!.localizedDescription
                finished = true
                vError = false
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    self.eMsg = parseJSON["msg"] as! String
                    if let strId = parseJSON["id"] as? NSNumber {
                        self.id = strId as! Int
                    } else {
                        self.id = Int(parseJSON["id"] as! String)!
                    }
                    self.photo.setPhoto(imageURL: parseJSON["photo"] as! String)
                    self.fname = parseJSON["fname"] as! String
                    self.lname = parseJSON["lname"] as! String
                    self.email = parseJSON["email"] as! String
                    self.bio = parseJSON["bio"] as! String
                    vError = !(parseJSON["error"] as! Bool)
                }
            } catch {
                self.eMsg = error.localizedDescription
                vError = false
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        return vError
    }
    
    public func addUser(newUser:(uname: String, pword: String, photo: Photo, fname: String, lname: String, email: String, bio: String)) -> Bool{
        // set up user object for database operations
        self.uname = newUser.uname
        self.pword = newUser.pword
        self.photo.copy(oldPhoto: newUser.photo)
        self.fname = newUser.fname
        self.lname = newUser.lname
        self.email = newUser.email
        self.bio = newUser.bio
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddUser.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let uname = self.uname
        let pword = self.pword
        let photo = self.photo.getPath()
        let fname = self.fname
        let lname = self.lname
        let email = self.email
        let bio = self.bio
        
        let params = "uname="+uname+"&pword="+pword+"&photo="+photo+"&fname="+fname+"&lname="+lname+"&email="+email+"&bio="+bio
        
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                self.eMsg = error!.localizedDescription
                finished = true
                vError = true
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    self.eMsg = parseJSON["msg"] as! String
                    if let strId = parseJSON["id"] as? NSNumber {
                        self.id = strId as! Int
                    } else {
                        self.id = Int(parseJSON["id"] as! String)!
                    }
                    vError = (parseJSON["error"] as! Bool)
                }
            } catch {
                self.eMsg = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        return vError        
    }
    
    public func updateUser(newUser:(uname: String, pword: String, photo: Photo, fname: String, lname: String, email: String, bio: String)) -> Bool {
        // set up user object for database operations
        self.pword = newUser.pword
        self.photo.copy(oldPhoto: newUser.photo)
        self.fname = newUser.fname
        self.lname = newUser.lname
        self.email = newUser.email
        self.bio = newUser.bio
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/UpdateUser.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let id = String(self.id)
        let pword = self.pword
        let photo = self.photo.getPath()
        let fname = self.fname
        let lname = self.lname
        let email = self.email
        let bio = self.bio
        
        var p = "id="+id+"&pword="+pword
            p = p + "&photo="+photo+"&fname="
            p = p + fname+"&lname="+lname
            p = p + "&email="+email+"&bio="+bio
        let params = p
        
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                self.eMsg = error!.localizedDescription
                finished = true
                vError = true
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    self.eMsg = parseJSON["msg"] as! String
                    vError = (parseJSON["error"] as! Bool)
                }
            } catch {
                self.eMsg = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        return vError
    }
    
    public func addPreference(key: String, value: Int) {
        self.preferences.append((key: key, value: value))
        // TODO: Run update to db here
    }
    
    public func removePreference(idx: Int) {
        self.preferences.remove(at: idx)
        // TODO: Run update to db here
    }
    
    public func copy(oldUser: User) {
        self.id = oldUser.id
        self.uname = oldUser.uname
        self.pword = oldUser.pword
        self.photo.copy(oldPhoto: oldUser.photo)
        self.fname = oldUser.fname
        self.lname = oldUser.lname
        self.email = oldUser.email
        self.bio = oldUser.bio
        self.eMsg = oldUser.eMsg
        self.preferences = [(key: String, value: Int)]()
        for p in oldUser.preferences {
            self.preferences.append((key: p.key, value: p.value))
        }
    }
    
    // Clear Method
    // @description
    // - Clears out all loaded data in a user object, use this before logging out to ensure user isn't logged in again
    public func clear() {
        id = -1
        uname = ""
        pword = ""
        photo = Photo()
        fname = ""
        lname = ""
        email = ""
        bio = ""
        eMsg = ""
        self.preferences = [(key: String, value: Int)]()
    }
    
    // getters and setters
    public func getId() -> Int { return self.id }
    public func getUname() -> String { return self.uname }
    public func getPword() -> String { return self.pword }
    public func getPhotoURL() -> String { return self.photo.getPath() }
    public func getPhoto() -> UIImage {return self.photo.getImage() }
    public func getFname() -> String { return self.fname }
    public func getLname() -> String { return self.lname }
    public func getEmail() -> String { return self.email }
    public func getBio() -> String { return self.bio }
    public func getEMsg() -> String { return self.eMsg }
    public func getPrefs() -> [(key: String, value: Int)] { return self.preferences }
}
