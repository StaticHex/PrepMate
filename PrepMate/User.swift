//
//  User.swift
//  PrepMate
//
//  Created by Joseph Bourque on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//
import UIKit
import Foundation

// User Preference Struct
// @members
// - id : (int) id of item stored in User_Preference table in REST API
// - key : (string) Will either be Category, Ingredient, or Type
// - value : (int) Will hold a specific entry to an array denoted by one of
//                 the key types listed above
// @description
// - This struct is used to hold a single user preference entry fetched from
//   the database. This is simply a data container and is used to help keep
//   code cleaner and easier to debug.
struct UserPreference {
    var id = -1
    var key = ""
    var value = 0
}

// User Record Struct
// @members
// - uname : (string) A unique identifier displayed for each user
// - pword : (string) Holds the user's salted + hashed password
// - photo : (string) Holds the URL path to the user's photo
// - fname : (string) Holds the user's first name (if it exists)
// - lname : (string) Holds the user's last name (if it exists)
// - email : (string) Holds the user's email, used for contact purposes
// - bio : (string) A snippet of text used as a short description of the user
// - preferences : (UserPreference) A list of preferences (used for add user only)
// @description
// - This struct is used to fetch, and modify data from within the user class before
//   updating the database record. (Similar to how a packet works in a network API)
struct UserRecord {
    var uname = ""
    var pword = ""
    var photo = ""
    var fname = ""
    var lname = ""
    var email = ""
    var bio = ""
    var preferences = [UserPreference]()
}

//! User Class
class User : CustomStringConvertible {
    private var id : Int // Holds the ID of a record stored in the User table
    private var uname : String // A unique identifier displayed for each user
    private var pword : String // The salted + hashed password in most cases
    private var photo : Photo // A photo object, not just the path
    private var fname : String // The user's first name
    private var lname : String // The user's last name
    private var email : String // The user's email address (for contact purposes)
    private var bio : String // A short description which describes the user
    private var eMsg : String // An error message variable, used for alerts and debug
    private var preferences : [UserPreference] // A list of the user's preferences (blacklist items)
    
    // print function description (used to override the print function)
    var description : String {
        var desc = "Id: \(self.id)\n"
        desc += "Username: \(self.uname)\n"
        desc += "Password: \(self.pword)\n"
        desc += "Photo: \(self.photo.getPath())\n"
        desc += "First Name: \(self.fname)\n"
        desc += "Last Name: \(self.lname)\n"
        desc += "Bio: \(self.bio)\n\n"
        desc += "preferences:\n"
        for p in preferences {
            var entry = ""
            switch(p.key) {
            case "Category":
                entry = categoryList[p.value]
                // TODO
                break
            case "Ingredient":
                entry = ingredientList[p.value].name
                // TODO
                break
            case "Type":
                entry = foodTypeList[p.value].name
                // TODO
                break
            default:
                break
            }
            desc += "    \(entry) --> \(String(p.key))\n"
        }
        desc += "\n"
        desc += "Error Message: \(self.eMsg)\n"
        return desc
    }
    
    // Init function, creates an empty user
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
        preferences = [UserPreference]()
    }
    
    // Verify User Method
    // @param
    // - uname: User name to log in with
    // - pword: unencrpted password to check against database hash
    // @description
    // - Pings the REST API with the user's username and password
    //   and either displays an alert in the event of a mismatch or
    //   logs the user in and grabs all information from the database
    // @return
    // - Returns (true) if user was successfully verified. Returns (false)
    //   and sets eMsg if the user could not be fetched for some reason
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
        
        // if there was no error, go ahead and load the user's preference list
        if(vError) {
            vError = !self.loadPrefList()
        }
        return vError
    }
    
    // Add User Method
    // @param
    // - newUser : (UserRecord) A collection of data representing the user to
    //                          be added to the database
    // @description
    // - Adds the passed record to the User table as well as adding all passed
    //   preferences to the User_Preference table. If the record is successfully
    //   added, the user object is updated, otherwise the user remains empty.
    // @returns
    // - Returns (true) if an error occured, otherwise returns (false) if the
    //   add was successful
    public func addUser(newUser:UserRecord) -> Bool {
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
        
        // set up params
        let uname = newUser.uname
        let pword = newUser.pword
        let photo = newUser.photo
        let fname = newUser.fname
        let lname = newUser.lname
        let email = newUser.email
        let bio = newUser.bio
        
        // create HTML body
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
        if(!vError) {
            for p in newUser.preferences {
                if(self.addPreference(pref: p)) {
                    vError = true
                    return vError
                }
            }
            
            // set up user object
            self.uname = newUser.uname
            self.pword = newUser.pword
            self.photo.setPhoto(imageURL: newUser.photo)
            self.fname = newUser.fname
            self.lname = newUser.lname
            self.email = newUser.email
            self.bio = newUser.bio
        }
        return vError
    }
    
    // Update User Method
    // @param
    // - newUser : (UserRecord) A data object to update the current user's information with
    // @description
    // - Takes in a UserRecord and overwrites the current record's information with that of the record passed in.
    // @return
    // - Returns (true) if an error occured, returns (false) if the update was successful
    public func updateUser(newUser:UserRecord) -> Bool {
        // Only allow an update if the user has a record to update
        if(self.id < 0) {
            self.eMsg = "User object does not exist, if you want to add user to database use addUser instead"
            return true
        }
        
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
        
        // Set up parameters
        let id = String(self.id)
        let pword = newUser.pword
        let photo = newUser.photo
        let fname = newUser.fname
        let lname = newUser.lname
        let email = newUser.email
        let bio = newUser.bio
        
        // Create HTTP Body
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
        
        // if there was no error, go ahead and update our user object
        if(!vError) {
            // set up user object for database operations
            self.pword = newUser.pword
            self.photo.setPhoto(imageURL: newUser.photo)
            self.fname = newUser.fname
            self.lname = newUser.lname
            self.email = newUser.email
            self.bio = newUser.bio
        }
        return vError
    }
    
    // Get User Method
    // @param
    // - uid : (int) id for an entry in the User table
    // @description
    // - Gets a specified entry from the User table and then sets all information
    //   in the user object according to the data returned from the query
    // @return
    // - Returns (true) if an error occured, returns (false) if the user was fetched
    //   sucessfully
    public func getUser(uid : Int) -> Bool {
        // set up user object for database operations
        self.id = uid
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/GetUser.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "id="+String(self.id)
        
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
                    self.uname = parseJSON["uname"] as! String
                    self.photo.setPhoto(imageURL: parseJSON["photo"] as! String)
                    self.fname = parseJSON["fname"] as! String
                    self.lname = parseJSON["lname"] as! String
                    self.email = parseJSON["email"] as! String
                    self.bio = parseJSON["bio"] as! String
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
        vError = self.loadPrefList()
        return vError
    }
    
    // Create Record Method
    // @description
    // - Creates a new UserRecord data object from the current user object
    // @return
    // - Returns a UserRecord object containing all information currently
    //   stored in the user object
    public func createRecord() -> UserRecord {
        var newRecord = UserRecord()
        newRecord.uname = self.uname
        newRecord.photo = self.photo.getPath()
        newRecord.fname = self.fname
        newRecord.lname = self.lname
        newRecord.email = self.email
        newRecord.pword = self.pword
        newRecord.bio = self.bio
        return newRecord
    }
    
    // Add Preference Method
    // @param
    // - pref (UserPreference) A preference data object containing the information
    //                         add to the User_Preference table
    // @description
    // - Takes in a new preference object and both adds an entry to the User_Preference
    //   table and also adds the entry to the preferences table within the user object
    // @return
    // - Returns (true) if an error occured, returns (false) if the preference was
    //   successfully added.
    public func addPreference(pref : UserPreference) -> Bool {
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // create a preference variable out of the passed preference which is immutable
        var newPref = pref
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddUserBList.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let uid = String(self.id)
        let bl_key = newPref.key
        let bl_value = String(newPref.value)
        
        let params = "uid="+uid+"&key="+bl_key+"&value="+bl_value
        
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
                    if let strId = parseJSON["code"] as? NSNumber {
                        newPref.id = strId as! Int
                    } else {
                        newPref.id = Int(parseJSON["code"] as! String)!
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
        
        // only append the preference to the list if the DB add was successful
        if(!vError) {
            self.preferences.append(newPref)
        }
        return vError
    }
    
    // Remove Preference Method
    // @param
    // - idx : (int) index in the preference table to remove
    // @description
    // - Removes the preference at the specified index from the user's preference
    //   list as well as removing the entry from the User_Preference table
    // @return
    // - Returns (true) if an error occured, returns (false) if the preference
    //   was successfully added.
    public func removePreference(idx: Int) -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/RemoveUserBList.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let id = String(self.preferences[idx].id)
        
        let params = "id="+id
        
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
        
        // Only remove from the list if entry was removed from the database
        if(!vError) {
            self.preferences.remove(at: idx)
        }
        
        return vError
    }
    
    // Clear Method
    // @description
    // - Clears out all loaded data in the current user object
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
        self.preferences = [UserPreference]()
    }
    
    // Load Preference List Method
    // @description
    // - Fetches all entries in the User_Preference table whose user id
    //   corresponds to the current user object's.
    // @return
    // - returns (true) if an error occured, returns (false) if the preference
    //   list was fetched successfully.
    private func loadPrefList() -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/GetUserBList.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let id = String(self.id)
        
        let params = "id="+id
        
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
                    if(!vError) {
                        var count = 0
                        while let record = parseJSON[String(count)] as? NSString {
                            if let entry = try JSONSerialization.jsonObject(with: record.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                                var newPref = UserPreference()
                                newPref.id = Int(entry["id"] as! String)!
                                newPref.key = entry["bl_key"] as! String
                                newPref.value = Int(entry["bl_Value"] as! String)!
                                self.preferences.append(newPref)
                            }
                            count+=1
                        }
                    }
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
    
    // Preference String Method
    // @description
    // - Fetches all entries in the User_Blacklist table and exports them as a single
    //   MySql query string
    // @return
    // - returns a mysql query string
    public func preferenceString() -> String {
        var cList = "category not in ("
        var fList = ""
        for p in preferences {
            switch(p.key) {
            case "Category":
                cList += "\(p.value), "
                // TODO
                break
            case "Ingredient":
                fList += "\(ingredientList[p.value].field)='false' AND "
                // TODO
                break
            case "Type":
                fList += "\(foodTypeList[p.value].field)='false' AND "
                // TODO
                break
            default:
                break
            }
        }
        
        // Trim extra characters off the end of the strings
        if cList != "category not in (" {
            cList = substring(tok: cList, begin: 0, end: cList.count-2)+")"
        } else {
            cList = ""
        }
        if fList != "" {
            fList = substring(tok: fList, begin: 0, end: fList.count-5)
        }
        if cList == "" && fList == "" {
            return ""
        }
        if cList == "" {
            return " AND "+fList
        }
        if fList == "" {
            return " AND "+cList
        }
        return " AND \(cList) AND \(fList)"
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
    public func getPref(idx : Int) -> UserPreference { return self.preferences[idx] }
    public func getPrefCount() -> Int { return self.preferences.count }
}

