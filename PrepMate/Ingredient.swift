//
//  Ingredient.swift
//  TestApp
//
//  Created by Joseph Bourque on 4/16/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//
import UIKit
import Foundation

// Ingredient Record Struct
// @members
// - name : (string) The name of the ingredient
// - unit : (int) An index into the unitList array
// - label : (string) A label to display in place of units, only
//                    set if the unit type is "custom"
// @description
// - This struct is used to fetch, and modify data from within the ingredient class before
//   updating the database record. (Similar to how a packet works in a network API)
struct IngredientRecord {
    var name = ""
    var unit = 0
    var label = ""
}

class Ingredient : CustomStringConvertible {
    private var id : Int // the row ID for the entry in the database table
    private var name : String // The ingredient's name
    private var unit : Int // Index into unitList array
    private var label : String // label to display in the event of type custom (1 bunch, a pinch, etc.)
    private var eMsg : String // used to hold error messages when/if they arise
    
    // override function for print, prints contents of class vs. address
    var description : String {
        var desc = "Id: \(self.id)\n"
        desc += "Name: \(self.name)\n"
        desc += "Unit: \(unitList[self.unit].std)/\(unitList[self.unit].metric)\n"
        desc += "Custom Unit Label: \(self.label)\n\n"
        desc += "Error Message: \(self.eMsg)\n"
        return desc
    }
    
    // default constructor, creates an empty ingredient object
    init() {
        self.id = -1
        self.name = ""
        self.unit = 0
        self.label = ""
        self.eMsg = ""
    }
    
    // Add Ingredient Method
    // @param
    // - newIngredient : (IngredientRecord) data object to create a new ingredient object
    //                                      from
    // @description
    // - Takes in a new ingredient object and adds a reference for it to the Ingredient
    //   table. This does NOT add a reference to the Recipe_Ingredients table
    // @return
    // - Returns (true) if an error occured, returns (false) if the ingredient was added
    //   successfully
    public func addIngredient(newIngredient : IngredientRecord)-> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddIngredient.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // Set up parameters
        let name = newIngredient.name
        let unit = String(newIngredient.unit)
        let custom = newIngredient.label
        
        // Create HTTP Body
        let params = "name="+name+"&unit="+unit+"&custom="+custom
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
            // set up user object for database operations
            self.name = newIngredient.name
            self.unit = newIngredient.unit
            self.label = newIngredient.label
        }
        return vError
    }
    
    // Get Ingredient Method
    // @param
    // - iid : (int) id for an entry in the Ingredient table
    // @description
    // - Gets a specified entry from the Ingredient table and then sets all information
    //   in the ingredient object according to the data returned from the query
    // @return
    // - Returns (true) if an error occured, returns (false) if the ingredient was fetched
    //   sucessfully
    public func getIngredient(iid:Int) -> Bool {
        // Set up user object for database operations
        self.id = iid
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/GetIngredient.php"
        
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
                self.id = -1
                vError = true
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    vError = (parseJSON["error"] as! Bool)
                    self.eMsg = parseJSON["msg"] as! String
                    self.name = parseJSON["name"] as! String
                    if let unit = Int(parseJSON["unit"] as! String) {
                        self.unit = unit
                    } else {
                        self.unit = 0
                    }
                    self.label = parseJSON["custom"] as! String
                }
            } catch {
                self.eMsg = error.localizedDescription
                self.id = -1
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        return vError
    }
    
    // Create Record Method
    // @description
    // - Creates a new IngredientRecord data object from the current ingredient object
    // @return
    // - Returns a IngredientRecord object containing all information currently
    //   stored in the ingredient object
    public func createRecord() -> IngredientRecord {
        var newRecord = IngredientRecord()
        newRecord.name = self.name
        newRecord.unit = self.unit
        newRecord.label = self.label
        return newRecord
    }
    
    // Clear Method
    // @description
    // - Clears out all loaded data in the current ingredient object
    public func clear() {
        self.id = -1
        self.name = ""
        self.unit = 0
        self.label = ""
        self.eMsg = ""
    }
    
    // getters (no setters)
    public func getId() -> Int { return self.id }
    public func getName() -> String { return self.name }
    public func getUnit() -> Int { return self.unit }
    public func getLabel() -> String { return self.label }
}
