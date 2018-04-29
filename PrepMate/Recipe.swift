//
//  Recipe.swift
//  TestApp
//
//  Created by Joseph Bourque on 4/17/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//
import UIKit
import Foundation

// Recipe Ingredient Struct
// @members
// - id : (int) id corresponding to an entry in the Recipe_Ingredient table
// - item : (Ingredient) holds all the information for an entry from the
//                     Ingredients table
// - amount : (Double) holds the amount of the current ingredient (in metric
//                     units).
// @description
// - Not to be confused with the Ingredient struct, this is a container used
//   to hold an ingredient as well as how much of that ingredient to store
//   in a recipe, pantry, shopping list, etc
struct RecipeIngredient {
    var id = -1
    var item = Ingredient()
    var amount = 0.0
}

// Recipe Direction Struct
// @members
// - id : (int) id corresponding to an entry in the Recipe_Direction table
// - description : (string) The direction's body text
// @description
// - A container object used to hold the information from an entry in the
//   Recipe_Direction table
struct Direction {
    var id = -1
    var description = ""
}

// Recipe Vitamin Struct
// @members
// - id : (int) id corresponding to an entry in the Recipe_Vitamin table
// - idx : (int) an index corresponding to an entry in the vitaminList
//               global array
// - percent : (Double) The daily percentage of the vitamin
// @description
// - A container object used to hold the information from an entry in the
//   Recipe_Vitamin table
struct Vitamin {
    var id = -1
    var idx = 0
    var percent = 0.0
}

// Recipe Comment Struct
// @members
// - id : (int) id corresponding to an entry in the Recipe_Comment table
// - userId : (int) id corresponding to an entry in the Users table
// - date : (string) the timestamp corresponding to when the comment was
//                   last updated (or added if never updated)
// - rating : (int) Index into the ratingsList image array
// - title : (String) Holds the title text for the comment
// - description : (String) Holds the body text for the comment
// @description
// - A container object used to hold the information from an entry in the
//   Recipe_Comment table
struct Comment {
    var id = -1
    var userId = -1
    var date = ""
    var rating = 0
    var title = ""
    var description = ""
}

// Recipe Record Struct
// @members
// - creatorId : (int) holds the id for the user who originally posted the recipe
// - name : (string) The name of the recipe
// - rating : (int) holds the rating for the recipe overall (average of all ratings)
// - photo : (string) holds the path to the cover image for the recipe
// - category : (int) holds an index into the categoryList and categoryPhoto arrays
// - servings : (string) holds how many servings the recipe is meant to produce
// - prepTime : (string) holds how long expected prep time will take
// - cook Time : (string) holds how long cook time is epxected to take
// - flags : (int) a bit vector representing a list of common allergens and dietary modifiers
// - calories : (double) the number of calories in the recipe
// - unsatFat : (double) the amount of unsaturated fat (in grams) in the recipe
// - satFat : (double) the amount of saturated fat (in grams) in the recipe
// - cholesterol : (double) the amount of cholesterol (in milligrams) in the recipe
// - sodium : (double) the amount of sodium (in milligrams) in the recipe
// - potassium : (double) the amount of potassium (in milligrams) in the recipe
// - carbs : (double) the amount of carbohydrates (in grams) in the recipe
// - fiber : (double) the amount of fiber (in grams) in the recipe
// - sugar : (double) the amount of sugar (in grams) in the recipe
// - ingredients : (RecipeIngredient) a list of ingredients pertaining to the recipe (used for the add function only)
// - directions : (Direction) a list of directions pertaining to the recipe (used for the add function only)
// - vitamins : (Vitamin) a list of vitamins pertaining to the recipe (used for the add function only)
// @description
// - This struct is used to fetch, and modify data from within the recipe class before
//   updating the database record. (Similar to how a packet works in a network API)
struct RecipeRecord {
    var creatorId = -1
    var name = ""
    var rating = 0
    var photo = ""
    var category = 0
    var servings = ""
    var prepTime = ""
    var cookTime = ""
    var flags = 0
    var calories = 0.0
    var unsatFat = 0.0
    var satFat = 0.0
    var cholesterol = 0.0
    var sodium = 0.0
    var potassium = 0.0
    var carbs = 0.0
    var fiber = 0.0
    var sugar = 0.0
    var ingredients = [RecipeIngredient]()
    var directions = [Direction]()
    var vitamins = [Vitamin]()
}

class Recipe : CustomStringConvertible {
    private var id : Int
    private var creatorId : Int
    private var name : String
    private var photo : Photo
    private var rating : Int
    private var category : Int
    private var servings : String
    private var prepTime : String
    private var cookTime : String
    private var flags : Int
    private var calories : Double
    private var unsatFat : Double
    private var satFat : Double
    private var cholesterol : Double
    private var sodium : Double
    private var potassium : Double
    private var carbs : Double
    private var fiber : Double
    private var sugar : Double
    private var ingredients : [RecipeIngredient]
    private var directions : [Direction]
    private var vitamins : [Vitamin]
    private var comments : [Comment]
    private var eMsg : String
    
    // override function for print, prints contents of class vs. address
    var description : String {
        var desc = "ID: \(self.id)\n"
        desc += "Creator ID: \(self.creatorId)\n"
        desc += "Name: \(self.name)\n"
        desc += "Photo: \(self.photo.getPath())\n"
        desc += "Rating: \(self.rating)\n"
        desc += "Category: \(categoryList[self.category])\n"
        desc += "Servings: \(self.servings)\n"
        desc += "Prep Time: \(self.prepTime)\n"
        desc += "Cook Time: \(self.cookTime)\n"
        desc += "Flags: \(self.flags)\n"
        desc += "Calories: \(self.calories) -- \(self.getCalories().percent)%\n"
        desc += "Unsaturated Fat: \(self.unsatFat) -- \(self.getUnsatFatG().percent)%\n"
        desc += "Saturated Fat: \(self.satFat) -- \(self.getSatFatG().percent)%\n"
        desc += "Cholesterol: \(self.cholesterol) -- \(self.getCholesterolMG().percent)%\n"
        desc += "Sodium: \(self.sodium) -- \(self.getSodiumMG().percent)%\n"
        desc += "Potassium: \(self.potassium) -- \(self.getPotassiumMG().percent)%\n"
        desc += "Carbs: \(self.carbs) -- \(self.getCarbsG().percent)%\n"
        desc += "Fiber: \(self.fiber) -- \(self.getFiberG().percent)%\n"
        desc += "Sugar: \(self.sugar) -- \(self.getSugarG().percent)%\n\n"
        desc += "Ingredients:\n"
        for i in self.ingredients {
            desc += "    \(i.item.getName()) -- \(i.amount) "
            if(i.item.getUnit() == 0) {
                desc += "\(i.item.getLabel())"
            } else {
                desc += unitList[i.item.getUnit()].std+"\n"
            }
            
        }
        desc += "\n\nDirections:\n"
        var count = 1
        for d in self.directions {
            var c = ""
            if(count < 10) {
                c = "0\(count)"
            } else {
                c = "\(count)"
            }
            desc += "    \(c). \(d.description)\n"
            count += 1
        }
        desc += "\n\nVitamins:\n"
        for v in self.vitamins {
            desc += "    \(vitaminList[v.idx]) -- \(v.percent)%\n"
        }
        desc += "\n\nComments:\n"
        for c in self.comments {
            desc += "    \(c.title) -- \(c.rating) : \(c.date)\n"
        }
        desc += "\n\n"
        desc += "Error Message: \(self.eMsg)\n"
        return desc
    }
    
    // default constructor, creates an empty recipe object
    init() {
        id = -1
        creatorId = -1
        name = ""
        rating = 0
        photo = Photo()
        category = 0
        servings = ""
        prepTime = "00:00:00"
        cookTime = "00:00:00"
        flags = 0
        calories = 0.0
        unsatFat = 0.0
        satFat = 0.0
        cholesterol = 0.0
        sodium = 0.0
        potassium = 0.0
        carbs = 0.0
        fiber = 0.0
        sugar = 0.0
        ingredients = [RecipeIngredient]()
        directions = [Direction]()
        vitamins = [Vitamin]()
        comments = [Comment]()
        eMsg = ""
    }
    // ================================================================================
    // Main class functions
    // ================================================================================
    
    // Add Recipe Method
    // @param
    // - newRecipe : (RecipeRecord) data object to create a new recipe object from
    // @description
    // - Takes in a new recipe record and adds a reference for it to the Recipes
    //   table.
    // @return
    // - Returns (true) if an error occured, returns (false) if the ingredient was added
    //   successfully
    public func addRecipe(newRecipe : RecipeRecord) -> Bool {
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddRecipe.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        var pString = "uid=\(newRecipe.creatorId)"
        pString += "&name=\(newRecipe.name)"
        pString += "&photo=\(newRecipe.photo)"
        pString += "&category=\(newRecipe.category)"
        pString += "&servings=\(newRecipe.servings)"
        pString += "&ptime=\(newRecipe.prepTime)"
        pString += "&ctime=\(newRecipe.cookTime)"
        pString += "&flags=\(newRecipe.flags)"
        pString += "&calories=\(newRecipe.calories)"
        pString += "&ufat=\(newRecipe.unsatFat)"
        pString += "&sfat=\(newRecipe.satFat)"
        pString += "&cholesterol=\(newRecipe.cholesterol)"
        pString += "&sodium=\(newRecipe.sodium)"
        pString += "&potassium=\(newRecipe.potassium)"
        pString += "&carbs=\(newRecipe.carbs)"
        pString += "&fiber=\(newRecipe.fiber)"
        pString += "&sugar=\(newRecipe.sugar)"
        
        let params = pString
        
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
                        self.id = strId as! Int
                    } else {
                        self.id = Int(parseJSON["code"] as! String)!
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
            // Fetch auxillary table entries (ingredients, directions, and vitamin)
            for i in newRecipe.ingredients {
                if(self.addRecipeIngredient(newIngredient: i)) {
                    vError = true
                    return vError
                }
            }
            for d in newRecipe.directions {
                if(self.addRecipeDirection(newDirection: d)) {
                    vError = true
                    return vError
                }
            }
            for v in newRecipe.vitamins {
                if(self.addRecipeVitamin(newVitamin: v)) {
                    vError = true
                    return vError
                }
            }
            
            // Only update object if DB functions were successfull
            self.creatorId = newRecipe.creatorId
            self.rating = newRecipe.rating
            self.name = newRecipe.name
            self.photo.setPhoto(imageURL: newRecipe.photo)
            self.category = newRecipe.category
            self.servings = newRecipe.servings
            self.prepTime = newRecipe.prepTime
            self.cookTime = newRecipe.cookTime
            self.flags = newRecipe.flags
            self.calories = newRecipe.calories
            self.unsatFat = newRecipe.unsatFat
            self.satFat = newRecipe.satFat
            self.cholesterol = newRecipe.cholesterol
            self.sodium = newRecipe.sodium
            self.potassium = newRecipe.potassium
            self.carbs = newRecipe.carbs
            self.fiber = newRecipe.fiber
            self.sugar = newRecipe.sugar
        }
        return vError
    }
    
    // Update Recipe Method
    // @param
    // - updateRecipe : (RecipeRecord) A data object to update the current recipe's information with
    // @description
    // - Takes in a RecipeRecord and overwrites the current record's information with that of the record passed in.
    // @return
    // - Returns (true) if an error occured, returns (false) if the update was successful
    public func updateRecipe(newRecipe : RecipeRecord) -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/UpdateRecipe.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        print(self)
        var pString = "id=\(self.id)"
        pString += "&uid=\(newRecipe.creatorId)"
        pString += "&name=\(newRecipe.name)"
        pString += "&photo=\(newRecipe.photo)"
        pString += "&category=\(newRecipe.category)"
        pString += "&servings=\(newRecipe.servings)"
        pString += "&ptime=\(newRecipe.prepTime)"
        pString += "&ctime=\(newRecipe.cookTime)"
        pString += "&flags=\(newRecipe.flags)"
        pString += "&calories=\(newRecipe.calories)"
        pString += "&ufat=\(newRecipe.unsatFat)"
        pString += "&sfat=\(newRecipe.satFat)"
        pString += "&cholesterol=\(newRecipe.cholesterol)"
        pString += "&sodium=\(newRecipe.sodium)"
        pString += "&potassium=\(newRecipe.potassium)"
        pString += "&carbs=\(newRecipe.carbs)"
        pString += "&fiber=\(newRecipe.fiber)"
        pString += "&sugar=\(newRecipe.sugar)"
        
        let params = pString
        
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
        
        // Only update recipe object if DB operation was successful
        if(!vError) {
            self.creatorId = newRecipe.creatorId
            self.rating = newRecipe.rating
            self.name = newRecipe.name
            self.photo.setPhoto(imageURL: newRecipe.photo)
            self.category = newRecipe.category
            self.servings = newRecipe.servings
            self.prepTime = newRecipe.prepTime
            self.cookTime = newRecipe.cookTime
            self.flags = newRecipe.flags
            self.calories = newRecipe.calories
            self.unsatFat = newRecipe.unsatFat
            self.satFat = newRecipe.satFat
            self.cholesterol = newRecipe.cholesterol
            self.sodium = newRecipe.sodium
            self.potassium = newRecipe.potassium
            self.carbs = newRecipe.carbs
            self.fiber = newRecipe.fiber
            self.sugar = newRecipe.sugar
        }
        return vError
    }
    
    public func getRecipe(rid : Int) -> Bool {
        // set class variables for db functionality
        self.id = rid
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/GetRecipe.php"
        
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
                    // Get the remaining information from our returned record (if it exists)
                    if let uid = parseJSON["uid"] as? String {
                        self.creatorId = Int(uid)!
                    } else {
                        self.creatorId = -1
                    }
                    self.name = parseJSON["name"] as! String
                    self.photo.setPhoto(imageURL: parseJSON["photo"] as! String)
                    if let cat = parseJSON["category"] as? Int {
                        self.category = cat
                    } else {
                        self.category = 0
                    }
                    self.servings = parseJSON["servings"] as! String
                    self.prepTime = parseJSON["ptime"] as! String
                    self.cookTime = parseJSON["ctime"] as! String
                    if let flg = parseJSON["flags"] as? Int {
                        self.flags = flg
                    } else {
                        self.flags = 0
                    }
                    if let cal = parseJSON["calories"] as? String {
                        self.calories = Double(cal)!
                    } else {
                        self.calories = 0.0
                    }
                    if let ufat = parseJSON["ufat"] as? String {
                        self.unsatFat = Double(ufat)!
                    } else {
                        self.unsatFat = 0.0
                    }
                    if let sfat = parseJSON["sfat"] as? String {
                        self.satFat = Double(sfat)!
                    } else {
                        self.satFat = 0.0
                    }
                    if let chol = parseJSON["cholesterol"] as? String {
                        self.cholesterol = Double(chol)!
                    } else {
                        self.cholesterol = 0.0
                    }
                    if let sod = parseJSON["sodium"] as? String {
                        self.sodium = Double(sod)!
                    } else {
                        self.sodium = 0.0
                    }
                    if let pot = parseJSON["potassium"] as? String {
                        self.potassium = Double(pot)!
                    } else {
                        self.potassium = 0.0
                    }
                    if let carb = parseJSON["carbs"] as? String {
                        self.carbs = Double(carb)!
                    } else {
                        self.potassium = 0.0
                    }
                    if let fib = parseJSON["fiber"] as? String {
                        self.fiber = Double(fib)!
                    } else {
                        self.fiber = 0.0
                    }
                    if let sug = parseJSON["sugar"] as? String {
                        self.sugar = Double(sug)!
                    } else {
                        self.sugar = 0.0
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
        
        
        // load in additional information from auxillary tables
        if(self.loadRecipeIngredients()) {
            vError = true
            return vError
        }
        if(self.loadRecipeDirections()) {
            vError = true
            return vError
        }
        if(self.loadRecipeVitamins()) {
            vError = true
            return vError
        }
        if(self.loadRecipeComments()) {
            vError = true
            return vError
        }
        return vError
    }
    
    public func removeRecipe() -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/RemoveRecipe.php"
        
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
        
        // Wipe recipe entry
        if(!vError) {
            self.clear()
        }
        return vError
    }
    
    
    
    public func clear() {
        id = -1
        creatorId = -1
        name = ""
        rating = 0
        photo = Photo()
        category = 0
        servings = ""
        prepTime = "00:00:00"
        cookTime = "00:00:00"
        flags = 0
        calories = 0.0
        unsatFat = 0.0
        satFat = 0.0
        cholesterol = 0.0
        sodium = 0.0
        potassium = 0.0
        carbs = 0.0
        fiber = 0.0
        sugar = 0.0
        ingredients = [RecipeIngredient]()
        directions = [Direction]()
        vitamins = [Vitamin]()
        comments = [Comment]()
        eMsg = ""
    }
    
    public func createRecord() -> RecipeRecord {
        var newRecord = RecipeRecord()
        newRecord.creatorId = self.creatorId
        newRecord.name = self.name
        newRecord.rating = self.rating
        newRecord.photo = self.photo.getPath()
        newRecord.category = self.category
        newRecord.servings = self.servings
        newRecord.prepTime = self.prepTime
        newRecord.cookTime = self.cookTime
        newRecord.flags = self.flags
        newRecord.calories = self.calories
        newRecord.unsatFat = self.unsatFat
        newRecord.satFat = self.satFat
        newRecord.cholesterol = self.cholesterol
        newRecord.sodium = self.sodium
        newRecord.potassium = self.potassium
        newRecord.carbs = self.carbs
        newRecord.fiber = self.fiber
        newRecord.sugar = self.sugar
        return newRecord
    }
    
    public func populateFromDict(query:NSDictionary)->Bool {
        do {
            // TODO: Populate base properties here
            if let rid = query["id"] as? String {
                self.id = Int(rid)!
            } else {
                eMsg = "Populate function errored while parsing id"
                return true
            }
            if let rInfo = query["info"]! as? NSDictionary {
                if let cid = rInfo["uid"] as? String {
                    self.creatorId = Int(cid)!
                } else {
                    eMsg = "Populate function errored while parsing creatorId"
                    return true
                }
                self.name = rInfo["name"] as! String
                self.photo.setPhoto(imageURL: rInfo["photo"] as! String)
                if let rank = rInfo["rating"] as? String {
                    self.rating = Int(rank)!
                } else {
                    eMsg = "Populate function errored while parsing rating"
                    return true
                }
                if let cat = rInfo["category"] as? String {
                    self.category = Int(cat)!
                } else {
                    eMsg = "Populate function errored while parsing category"
                    return true
                }
                self.servings = rInfo["servings"] as! String
                self.prepTime = rInfo["ptime"] as! String
                self.cookTime = rInfo["ctime"] as! String
                self.flags = rInfo["flags"] as! Int
                if let cal = rInfo["calories"] as? String {
                    self.calories = Double(cal)!
                } else {
                    eMsg = "Populate function errored while parsing calories"
                    return true
                }
                if let ufat = rInfo["ufat"] as? String {
                    self.unsatFat =  Double(ufat)!
                } else {
                    eMsg = "Populate function errored while parsing unsat. fat"
                    return true
                }
                if let sfat = rInfo["sfat"] as? String {
                    self.satFat = Double(sfat)!
                } else {
                    eMsg = "Populate function errored while parsing sat. fat"
                    return true
                }
                if let chol = rInfo["cholesterol"] as? String {
                    self.cholesterol = Double(chol)!
                } else {
                    eMsg = "Populate function errored while parsing cholesterol"
                    return true
                }
                if let sod = rInfo["sodium"] as? String {
                    self.sodium = Double(sod)!
                } else {
                    eMsg = "Populate function errored while parsing sodium"
                    return true
                }
                if let pot = rInfo["potassium"] as? String {
                    self.potassium = Double(pot)!
                } else {
                    eMsg = "Populate function errored while parsing potassium"
                    return true
                }
                if let car = rInfo["carbs"] as? String {
                    self.carbs = Double(car)!
                } else {
                    eMsg = "Populate function errored while parsing carbs"
                    return true
                }
                if let fib = rInfo["fiber"] as? String {
                    self.fiber = Double(fib)!
                } else {
                    eMsg = "Populate function errored while parsing fiber"
                    return true
                }
                if let sug = rInfo["sugar"] as? String {
                    self.sugar = Double(sug)!
                }else {
                    eMsg = "Populate function errored while parsing sugar"
                    return true
                }
            } else {
                eMsg = "Populate function errored while trying to parse recipe info"
                return true
            }
            
            // Populate our ingredients
            var ingCount = 0
            if let newIngredients = query["ingredients"]! as? NSDictionary {
                while let ingRecord = newIngredients[String(ingCount)] as? NSString {
                    if let ingEntry = try JSONSerialization.jsonObject(with: ingRecord.data(using:
                        String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                        var newRIngredient = RecipeIngredient()
                        if let rid = ingEntry["id"] as? String {
                            newRIngredient.id = Int(rid)!
                        } else {
                            newRIngredient.id = -1
                            self.eMsg = "Populate Function errored while parsing ingredient id"
                            return true
                        }
                        if let amt = ingEntry["amount"] as? String {
                            newRIngredient.amount = Double(amt)!
                        } else {
                            self.eMsg = "Populate Function errored while parsing ingredient amount"
                            return true
                        }
                        if let ingInfo = ingEntry["ingredient_id"] as? NSDictionary {
                            if(!newRIngredient.item.populateFromDict(query: ingInfo)) {
                                self.ingredients.append(newRIngredient)
                            } else {
                                self.eMsg = "An error occured while populating an ingredient"
                                return true
                            }
                        } else {
                            self.eMsg = "Populate Function errored while parsing ingredient item"
                            return true
                        }
                    }
                    ingCount+=1
                }
            } else {
                self.eMsg = "Populate Function errored while parsing ingredients"
                return true
            }
            // TODO: Populate directions here
            var dirCount = 0
            if let newDirections = query["directions"] as? NSDictionary {
                while let dirRecord = newDirections[String(dirCount)] as? NSString {
                    if let dirEntry = try JSONSerialization.jsonObject(with: dirRecord.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                        var newDir = Direction()
                        if let did = dirEntry["id"] as? String {
                            newDir.id = Int(did)!
                        } else {
                            self.eMsg = "Populate function errored while parsing direction id"
                            return true
                        }
                        newDir.description = dirEntry["description"] as! String
                        self.directions.append(newDir)
                    }
                    dirCount+=1
                }
            }
            // TODO: Populate vitamin info here
            var vitCount = 0
            if let newVitamins = query["vitamins"] as? NSDictionary {
                while let vitRecord = newVitamins[String(vitCount)] as? NSString {
                    if let vitEntry = try JSONSerialization.jsonObject(with: vitRecord.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                        var newVit = Vitamin()
                        if let vid = vitEntry["id"] as? String {
                            newVit.id = Int(vid)!
                        } else {
                            self.eMsg = "Populate function errored while parsing vitamin id"
                            return true
                        }
                        if let vidx = vitEntry["idx"] as? String {
                            newVit.idx = Int(vidx)!
                        } else {
                            self.eMsg = "Populate function errored while parsing vitamin index"
                            return true
                        }
                        if let vper = vitEntry["daily_percent"] as? String {
                            newVit.percent = Double(vper)!
                        } else {
                            self.eMsg = "Populate function errored while parsing vitamin percent"
                            return true
                        }
                        self.vitamins.append(newVit)
                    }
                    vitCount += 1
                }
            }
            // TODO: Populate comments here
            var comCount = 0
            if let newComments = query["comments"] as? NSDictionary {
                while let comRecord = newComments[String(comCount)] as? NSString {
                    if let comEntry = try JSONSerialization.jsonObject(with: comRecord.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                        var newCom = Comment()
                        if let cid = comEntry["id"] as? String {
                            newCom.id = Int(cid)!
                        } else {
                            self.eMsg = "Populate function errored while parsing comment id"
                            return true
                        }
                        newCom.date = comEntry["date_posted"] as! String
                        if let uid = comEntry["user_id"] as? String {
                            newCom.userId = Int(uid)!
                        } else {
                            self.eMsg = "Populate function errored while parsing user id"
                            return true
                        }
                        newCom.title = comEntry["title"] as! String
                        newCom.description = comEntry["description"] as! String
                        if let rtg = comEntry["rating"] as? String {
                            newCom.rating = Int(rtg)!
                        } else {
                            self.eMsg = "Populate function errored while parsing comment rating"
                            return true
                        }
                        self.comments.append(newCom)
                    }
                    comCount += 1
                }
            }
        } catch {
            self.eMsg = error.localizedDescription
        }
        return false
    }

    public func getNutritionDict() -> [String: (amount : Double, percent: Double)] {
        var result = [String: (amount : Double, percent: Double)]()
        result["Calories"] = self.getCalories()
        result["Unsat. Fat"] = self.getUnsatFatG()
        result["Sat. Fat"] = self.getSatFatG()
        result["Cholesterol"] = self.getCholesterolMG()
        result["Sodium"] = self.getSodiumMG()
        result["Potassium"] = self.getPotassiumMG()
        result["Carbs"] = self.getCarbsG()
        result["Fiber"] = self.getFiberG()
        result["Sugar"] = self.getSugarG()
        return result
    }
    
    // getters (no setters)
    public func getId() -> Int { return self.id }
    public func getCreatorId() -> Int { return self.creatorId }
    public func getName() -> String { return self.name }
    public func getPhoto() -> UIImage { return self.photo.getImage() }
    public func getCategory() -> Int { return self.category }
    public func getServings() -> String { return self.servings }
    public func getPrepTime() -> String { return self.prepTime }
    public func getCookTime() -> String { return self.cookTime }
    public func getFlags() -> Int { return self.flags }
    public func getRating() -> Int { return self.rating }
    public func getCalories() -> (amount : Double, percent : Double ) {
        return (amount: self.calories, percent: roundP(p: (self.calories / 2000.0) * 100.0))
    }
    public func getUnsatFatG() -> (amount : Double, percent : Double) {
        return (amount : self.unsatFat, percent: roundP(p: (self.unsatFat / 66.36) * 100.0))
    }
    public func getSatFatG() -> (amount:Double, percent:Double) {
        return (amount : self.satFat, percent:roundP(p: (self.satFat / 66.36) * 100.0))
    }
    public func getCholesterolMG() -> (amount:Double, percent:Double) {
        return (amount : self.cholesterol, percent: roundP(p: (self.cholesterol / 300.0) * 100.0))
    }
    public func getSodiumMG() -> (amount:Double, percent:Double) {
        return (amount : self.sodium, percent: roundP(p: (self.sodium / 2300.0) * 100.0))
    }
    public func getPotassiumMG() -> (amount : Double, percent : Double) {
        return (amount : self.potassium, percent: roundP(p: (self.potassium / 4700.0) * 100.0))
    }
    public func getCarbsG() -> (amount : Double, percent : Double) {
        return (amount : self.carbs, percent: roundP(p: (self.carbs / 275) * 100.0))
    }
    public func getFiberG() -> (amount : Double, percent : Double) {
        return (amount : self.fiber, percent: roundP(p: (self.fiber / 15.0) * 100.0))
    }
    public func getSugarG() -> (amount: Double, percent: Double) {
        return (amount : self.sugar, percent: roundP(p: (self.sugar / 25.0) * 100.0))
    }
    public func getEMsg() -> String { return eMsg }
    
    
    
    // ================================================================================
    // Recipe Ingredient functions
    // ================================================================================
    public func addRecipeIngredient(newIngredient : RecipeIngredient) -> Bool {
        var ing = newIngredient
        
        var vError = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddRecipeIngredient.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        var pString = "rid=\(String(self.id))"
        pString += "&iid=\(String(ing.item.getId()))"
        pString += "&amount=\(String(ing.amount))"
        
        let params = pString
        
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
                        ing.id = strId as! Int
                    } else {
                        ing.id = Int(parseJSON["id"] as! String)!
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
            self.ingredients.append(ing)
        }
        return vError
    }
    
    public func updateRecipeIngredient(idx : Int, newAmount : Double) -> Bool {
        // set up variables for db operations
        self.ingredients[idx].amount = newAmount
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/UpdateRecipeIngredient.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        var pString = "id=\(String(self.ingredients[idx].id))"
        pString += "&rid=\(String(self.id))"
        pString += "&iid=\(String(self.ingredients[idx].item.getId()))"
        pString += "&amount=\(String(self.ingredients[idx].amount))"
        
        let params = pString
        
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
    
    public func removeRecipeIngredient(idx:Int) -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/RemoveRecipeIngredient.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "id="+String(self.ingredients[idx].id)
        
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
        
        // Wipe recipe entry
        if(!vError) {
            self.ingredients.remove(at: idx)
        }
        return vError
    }
    
    private func loadRecipeIngredients() -> Bool {
        // TODO: Write this funciton
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/GetRecipeIngredients.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "id=\(String(self.id))"
        
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
                                var newIng = RecipeIngredient()
                                if let strId = entry["id"] as? String {
                                    newIng.id = Int(strId)!
                                } else {
                                    vError = true
                                    break
                                }
                                if let iid = entry["ingredient_id"] as? String {
                                    if(Int(iid)! >= 0) {
                                        DispatchQueue.main.async {
                                            if(newIng.item.getIngredient(iid: Int(iid)!)){
                                                vError = true
                                            }
                                        }
                                        if(vError) {
                                            break
                                        }
                                    }
                                }
                                if let strAmt = entry["amount"] as? String {
                                    newIng.amount = Double(strAmt)!
                                } else {
                                    vError = true
                                    break
                                }
                                self.ingredients.append(newIng)
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
    
    // Getters (no setters)
    public func getNumIngredients() -> Int { return self.ingredients.count }
    public func getRecipeIngredient(idx:Int) -> RecipeIngredient { return self.ingredients[idx] }
    
    // ================================================================================
    // Recipe Direction functions
    // ================================================================================
    public func addRecipeDirection(newDirection: Direction) -> Bool {
        var dir = newDirection
        
        var vError = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddRecipeDirection.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        var pString = "rid=\(String(self.id))"
        pString += "&description=\(String(dir.description))"
        
        let params = pString
        
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
                        dir.id = strId as! Int
                    } else {
                        dir.id = Int(parseJSON["id"] as! String)!
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
            self.directions.append(dir)
        }
        return vError
    }
    
    public func updateRecipeDirection(idx: Int, newDescription : String) -> Bool {
        // set up variables for db operations
        self.directions[idx].description = newDescription
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/UpdateRecipeDirection.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        var pString = "id=\(String(self.directions[idx].id))"
        pString += "&rid=\(String(self.id))"
        pString += "&description=\(String(self.directions[idx].description))"
        
        let params = pString
        
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
    
    public func removeRecipeDirection(idx: Int) -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/RemoveRecipeDirection.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "id="+String(self.directions[idx].id)
        
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
        
        // Wipe recipe entry
        if(!vError) {
            self.directions.remove(at: idx)
        }
        return vError
    }
    
    private func loadRecipeDirections() -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/GetRecipeDirections.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "id=\(String(self.id))"
        
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
                                var newDir = Direction()
                                if let strId = entry["id"] as? String {
                                    newDir.id = Int(strId)!
                                } else {
                                    vError = true
                                    break
                                }
                                newDir.description = entry["description"] as! String
                                self.directions.append(newDir)
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
    
    // Getters (no setters)
    public func getNumDirections() -> Int { return self.directions.count }
    public func getRecipeDirection(idx : Int) -> Direction { return self.directions[idx] }
    
    // ================================================================================
    // Recipe Vitamin functions
    // ================================================================================
    public func addRecipeVitamin(newVitamin : Vitamin) -> Bool {
        var vit = newVitamin
        
        var vError = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddRecipeVitamin.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        var pString = "rid=\(String(self.id))"
        pString += "&idx=\(String(vit.idx))"
        pString += "&percent=\(String(vit.percent))"
        
        let params = pString
        
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
                        vit.id = strId as! Int
                    } else {
                        vit.id = Int(parseJSON["id"] as! String)!
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
            self.vitamins.append(vit)
        }
        return vError
    }
    
    public func updateRecipeVitamin(idx : Int, newPercent : Double) -> Bool {
        // set up variables for db operations
        self.vitamins[idx].percent = newPercent
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/UpdateRecipeVitamin.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        var pString = "id=\(String(self.vitamins[idx].id))"
        pString += "&rid=\(String(self.id))"
        pString += "&idx=\(String(self.vitamins[idx].idx))"
        pString += "&percent=\(String(self.vitamins[idx].percent))"
        
        let params = pString
        
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
    
    public func removeRecipeVitamin(idx : Int) -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/RemoveRecipeVitamin.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "id="+String(self.vitamins[idx].id)
        
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
        
        // Wipe recipe entry
        if(!vError) {
            self.vitamins.remove(at: idx)
        }
        return vError
    }
    
    private func loadRecipeVitamins() -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/GetRecipeVitamins.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "id=\(String(self.id))"
        
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
                                var newVit = Vitamin()
                                if let strId = entry["id"] as? String {
                                    newVit.id = Int(strId)!
                                } else {
                                    vError = true
                                    break
                                }
                                if let strIdx = entry["idx"] as? String {
                                    newVit.idx = Int(strIdx)!
                                } else {
                                    vError = true
                                    break
                                }
                                if let strPer = entry["daily_percent"] as? String {
                                    newVit.percent = Double(strPer)!
                                } else {
                                    vError = true
                                    break
                                }
                                self.vitamins.append(newVit)
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
    
    // Getters (no setters)
    public func getNumVitamin() -> Int { return self.vitamins.count }
    public func getRecipeVitamin(idx : Int) -> Vitamin { return self.vitamins[idx] }
    
    // ================================================================================
    // Recipe Comment functions
    // ================================================================================
    public func addRecipeComment(newComment : Comment) -> Bool {
        // create mutable object
        var com = newComment
        
        // set the timestamp
        com.date = getTimestamp()
        
        var vError = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddRecipeComment.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // set params
        var pString = "rid=\(String(self.id))"
        pString += "&uid=\(String(com.userId))"
        pString += "&date=\(com.date)"
        pString += "&rating=\(String(com.rating))"
        pString += "&title=\(com.title)"
        pString += "&description=\(com.description)"
        
        let params = pString
        
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
                        com.id = strId as! Int
                    } else {
                        com.id = Int(parseJSON["id"] as! String)!
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
            self.comments.append(com)
        }
        return vError
    }
    
    public func updateRecipeComment(idx: Int, newTitle : String, newRating : Int, newDescription : String) -> Bool {
        
        // set the timestamp
        let date = getTimestamp()
        
        var vError = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/UpdateRecipeComment.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // set params
        var pString = "id=\(String(self.comments[idx].id))"
        pString += "&rid=\(String(self.id))"
        pString += "&uid=\(String(self.comments[idx].userId))"
        pString += "&date=\(date)"
        pString += "&rating=\(newRating)"
        pString += "&title=\(newTitle)"
        pString += "&description=\(newDescription)"
        
        let params = pString
        
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
        
        if(!vError) {
            self.comments[idx].date = date
            self.comments[idx].title = newTitle
            self.comments[idx].rating = newRating
            self.comments[idx].description = newDescription
        }
        return vError
    }
    
    public func removeRecipeComment(idx : Int) -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/RemoveRecipeComment.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "id="+String(self.comments[idx].id)
        
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
        
        // Wipe recipe entry
        if(!vError) {
            self.comments.remove(at: idx)
        }
        return vError
    }
    
    public func getFilteredRecipeComments(query : String) -> Bool {
        // FIELDS
        // id(key), recipe_id, user_id, date_posted, rating, title, description
        
        self.comments.removeAll()
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/GetFilteredComments.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        
        // Note: Start fed in query with " AND"
        let q = "recipe_id=\(self.id) \(query)"
        
        let params = "query=\(q)"
        print("QUERY: \(params)")
        
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
                            if vError {
                                break
                            }
                            if let entry = try JSONSerialization.jsonObject(with: record.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                                var newCom = Comment()
                                if let strId = entry["id"] as? String {
                                    newCom.id = Int(strId)!
                                } else {
                                    vError = true
                                    break
                                }
                                if let strUid = entry["user_id"] as? String {
                                    newCom.userId = Int(strUid)!
                                } else {
                                    vError = true
                                    break
                                }
                                newCom.date = entry["date_posted"] as! String
                                if let strRate = entry["rating"] as? String {
                                    newCom.rating = Int(strRate)!
                                } else {
                                    vError = true
                                    break
                                }
                                newCom.title = entry["title"] as! String
                                newCom.description = entry["description"] as! String
                                self.comments.append(newCom)
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
    
    public func resetRecipeComments() {
        self.comments.removeAll()
        self.loadRecipeComments()
    }
    
    private func loadRecipeComments() -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/GetRecipeComments.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "id=\(String(self.id))"
        
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
                        if let strRating = parseJSON["rank"] as? Int {
                            self.rating = strRating
                        } else {
                            vError = true
                        }
                        
                        var count = 0
                        while let record = parseJSON[String(count)] as? NSString {
                            if vError {
                                break
                            }
                            if let entry = try JSONSerialization.jsonObject(with: record.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                                var newCom = Comment()
                                if let strId = entry["id"] as? String {
                                    newCom.id = Int(strId)!
                                } else {
                                    vError = true
                                    break
                                }
                                if let strUid = entry["user_id"] as? String {
                                    newCom.userId = Int(strUid)!
                                } else {
                                    vError = true
                                    break
                                }
                                newCom.date = entry["date_posted"] as! String
                                if let strRate = entry["rating"] as? String {
                                    newCom.rating = Int(strRate)!
                                } else {
                                    vError = true
                                    break
                                }
                                newCom.title = entry["title"] as! String
                                newCom.description = entry["description"] as! String
                                self.comments.append(newCom)
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
    
    // Getter s (no setters)
    public func getNumComment() -> Int { return self.comments.count }
    public func getRecipeComment(idx : Int) -> Comment { return self.comments[idx] }
    
    // helper functions
    private func roundP(p : Double) -> Double { return (p * 100.0).rounded() / 100.0 }
}
