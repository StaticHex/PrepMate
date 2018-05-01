//
//  Meal.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 4/28/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation
class Meal {
    public var mealId: Int
    public var creatorId: Int
    public var name: String
    public var eMsg: String
    init(){
        self.mealId = -1
        self.creatorId = -1
        self.name = ""
        self.eMsg = ""
    }
    init(mId:Int, uid: Int, name: String, eMsg: String){
        self.mealId = mId
        self.creatorId = uid
        self.name = name
        self.eMsg = eMsg
    }
    public func addMeal(uid: Int, name: String) ->Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddMeal.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "uid=\(uid)&name=\(name)"
        
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
                        self.mealId = strId as! Int
                    } else {
                        self.mealId = Int(parseJSON["code"] as! String)!
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
        print("MEAL ID: \(self.mealId)")
        return vError
    }
    public func addMealRecipe(rid:Int)->Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddMealRecipe.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        print("RID ADDED: \(rid)")
        print("MEALID ADDED TO: \(self.mealId)")
        let params = "mid=\(self.mealId)&rid=\(rid)"
        
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
    func getMealRecipes() -> [Recipe] {
        var recipes = [Recipe]()
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/GetMealRecipes.php"
        
        var mealEMsg: String = ""
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let params = "mid=\(self.mealId)"
        
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                mealEMsg = error!.localizedDescription
                finished = true
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                print(JSONResponse)
                
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    mealEMsg = parseJSON["msg"] as! String
                    let vError = (parseJSON["error"] as! Bool)
                    if(!vError) {
                        var count = 0
                        while let record = parseJSON[String(count)] as? NSString {
                            if let entry = try JSONSerialization.jsonObject(with: record.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                                print(count)
                                var newRecipe = Recipe()
                                if let rId = entry["recipe_id"] as? NSString {
                                    if let recipeInfo = try JSONSerialization.jsonObject(with: rId.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                                        if(!newRecipe.populateFromDict(query: recipeInfo)) {
                                            recipes.append(newRecipe)
                                        } else {
                                            print(newRecipe.getEMsg())
                                        }
                                    }
                                } else {
                                    self.eMsg = "Populate function errored while parsing recipe info"
                                    return
                                }
                               
                            }
                            count+=1
                        }
                    } else {
                        recipes.removeAll()
                        print(mealEMsg)
                        return
                    }
                }
            } catch {
                mealEMsg = error.localizedDescription
                recipes.removeAll()
                return
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        
        return recipes
    }
    func 
    
}
