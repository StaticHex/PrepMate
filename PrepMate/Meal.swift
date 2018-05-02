//
//  Meal.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 4/28/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation

// Meal Class
// @members
// - mealId: (Int) holds the id of the current meal
// - creatorId : (Int) holds the id of the user who created this meal
// - name: (String) holds the name of the current meal
// - eMsg: (String) holds any associated error messages
// @description
// - This class represents a meal which holds associated recipes that are meant to be cooked together.
class Meal {
    public var mealId: Int
    public var creatorId: Int
    public var name: String
    public var eMsg: String
    // Default constructor
    // @description
    // - Creates an empty Meal object
    init(){
        self.mealId = -1
        self.creatorId = -1
        self.name = ""
        self.eMsg = ""
    }
    // Secondary Constructor
    // @params
    // - mId: (Int) the meal id for this meal
    // - uid: (Int) the user id who created the meal
    // - name: (String) the name to give this meal
    // - eMsg: (String) error message for the meal, likely an empty string
    // @description
    // - Creates a Meal object with given parameters
    init(mId:Int, uid: Int, name: String, eMsg: String){
        self.mealId = mId
        self.creatorId = uid
        self.name = name
        self.eMsg = eMsg
    }
    // Add Meal Function
    // @params
    // - uid: (Int) The user id of creator of the meal
    // - name: (String) The name of the new meal
    // @description
    // - Creates a new meal and adds it to the database. This function will set the mealId of the new meal
    // @return
    // - Returns (true) if an error occurred or (false) otherwise.
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
                    // Set the new mealId
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
        return vError
    }
    // Cook Meal function
    // @description
    // - "Cooks" a meal which subtracts the ingredients contained in the meal from the pantry record
    // @return
    // - Returns (true) if an error occurred, returns (false) otherwise.
    public func cookMeal()->Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/CookMeal.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let params = "uid=\(currentUser.getId())&mid=\(self.mealId)"
        
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
    // Add Meal Recipe Function
    // @params
    // - rid: (Int) The id of the recipe to add to the current meal
    // @description
    // - Adds a recipe to the current meal
    // @return
    // - Returns (true) if an error occurred, (false) otherwise.
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
    // Get Meal Recipes Function
    // @description
    // - Retrieves the recipes associated with the current meal
    // @return
    // - Returns a tuple containing a list of Recipe objects and a list of the associated Meal Recipe Ids
    func getMealRecipes() -> (recipe:[Recipe], mIds: [Int]) {
        var recipes = [Recipe]()
        var mealRecipeIds = [Int]()
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
                
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    mealEMsg = parseJSON["msg"] as! String
                    let vError = (parseJSON["error"] as! Bool)
                    if(!vError) {
                        var count = 0
                        while let record = parseJSON[String(count)] as? NSString {
                            if let entry = try JSONSerialization.jsonObject(with: record.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                                // Parse the Recipe information
                                let newRecipe = Recipe()
                                if let rId = entry["recipe_id"] as? NSString {
                                    if let recipeInfo = try JSONSerialization.jsonObject(with: rId.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                                        if(!newRecipe.populateFromDict(query: recipeInfo)) {
                                            // Add the new Recipe object and the corresponding Meal Recipe Id to the lists
                                            recipes.append(newRecipe)
                                            mealRecipeIds.append(Int(entry["id"] as! String)!)
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
        
        return (recipe:recipes, mIds: mealRecipeIds)
    }
    // Meal to Shopping List Function
    // @description
    // - Exports the ingredients of the recipes within the current meal to the shopping list
    // @return
    // - returns (true) if an error occurred, (false) otherwise.
    public func mealToSL()->Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/MealToSL.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let params = "uid=\(currentUser.getId())&mid=\(self.mealId)"
        
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
    
}
