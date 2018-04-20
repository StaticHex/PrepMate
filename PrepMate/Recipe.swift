//
//  Recipe.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation
import UIKit
class Recipe {
    private var id : Int
    private var name : String
    private var photo : Photo
    private var category : Int
    private var servings : Int
    private var prepTime : String
    private var cookTime : String
    private var calories : Int
    private var unsatFat : Int
    private var satFat : Int
    private var cholesterol : Int
    private var sodium : Int
    private var potassium : Int
    private var carbs : Int
    private var fiber : Int
    private var sugar : Int
    private var comments : [Comment]
    private var ingredients : [(id:Int,ing:Ingredient, amount:Float)]
    private var directions : [(id:Int, str:String)]
    private var rating: Int
    private var flags: Int
    private var vitamin : [Vitamin]
    init() {
        self.id = -1
        self.name = ""
        self.photo = Photo()
        self.category = -1
        self.servings = -1
        self.prepTime = "00:00:00"
        self.cookTime = "00:00:00"
        self.calories = -1
        self.unsatFat = -1
        self.satFat = -1
        self.cholesterol = -1
        self.sodium = -1
        self.potassium = -1
        self.carbs = -1
        self.fiber = -1
        self.sugar = -1
        self.comments = [Comment]()
        self.ingredients = [(id:Int,ing:Ingredient, amount:Float)]()
        self.directions = [(id:Int, str:String)]()
        self.rating = 0
        self.flags = 0
        self.vitamin = [Vitamin]()
    }
    init(id:Int, name:String, photo:Photo, category:Int, servings:Int, prepTime:String, cookTime:String, calories:Int, unsatFat:Int, satFat:Int, cholesterol:Int, sodium:Int, potassium:Int, carbs:Int, fiber:Int, sugar:Int, comments:[Comment], ingredients:[(id:Int, ing:Ingredient, amount:Float)], directions:[(id:Int, str:String)], rating:Int, flags:Int, vitamin:[Vitamin]) {
        self.id = id
        self.name = name
        self.photo = photo
        self.category = category
        self.servings = servings
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.calories = calories
        self.unsatFat = unsatFat
        self.satFat = satFat
        self.cholesterol = cholesterol
        self.sodium = sodium
        self.potassium = potassium
        self.carbs = carbs
        self.fiber = fiber
        self.sugar = sugar
        self.comments = comments
        self.ingredients = ingredients
        self.directions = directions
        self.rating = rating
        self.flags = flags
        self.vitamin = vitamin
    }
    
    // Setter functions for class variables
    public func setId(id: Int) { self.id = id}
    public func setName(name: String) { self.name = name}
    public func setPhoto(photo: Photo) { self.photo = photo}
    public func setCategory(category: Int) { self.category = category}
    public func setServings(servings: Int) { self.servings = servings}
    public func setPrepTime(prepTime: String) { self.prepTime = prepTime}
    public func setCookTime(cookTime: String) { self.cookTime = cookTime}
    public func setCalories(calories: Int) { self.calories = calories}
    public func setUnsatFat(unsatFat: Int) { self.unsatFat = unsatFat}
    public func setSatFat(satFat: Int) { self.satFat = satFat}
    public func setCholesterol(cholesterol: Int) { self.cholesterol = cholesterol}
    public func setSodium(sodium: Int) { self.sodium = sodium}
    public func setPotassium(potassium: Int) { self.potassium = potassium}
    public func setCarbs(carbs : Int) { self.carbs = carbs}
    public func setFiber(fiber: Int) { self.fiber = fiber}
    public func setSugar(sugar: Int) { self.sugar = sugar}
    public func setComments(comments: [Comment]) { self.comments = comments}
    public func setIngredients(ingredients: [(id:Int,ing:Ingredient, amount:Float)]) { self.ingredients = ingredients}
    public func setDirections(directions: [(id:Int, str:String)]) { self.directions = directions}
    public func setRating(rating: Int) { self.rating = rating}
    public func setFlags(flags: Int) { self.flags = flags}
    public func setVitamin(vitamin: [Vitamin]) { self.vitamin = vitamin}
    
    
    // Getter functions for class variables
    public func getId() -> Int { return self.id }
    public func getName() -> String { return self.name }
    public func getPhoto() -> UIImage { return self.photo.getImage()}
    public func getCategory() -> Int { return self.category}
    public func getServings() -> Int { return self.servings}
    // TODO: Possibly need to do processing for times over an hour
    public func getPrepTime() -> String { return self.prepTime}
    public func getCookTime() -> String { return self.cookTime}
    public func getCalories() -> Int { return self.calories}
    public func getUnsatFat() -> Int { return self.unsatFat}
    public func getSatFat() -> Int { return self.satFat}
    public func getCholesterol() -> Int { return self.cholesterol}
    public func getSodium() -> Int { return self.sodium}
    public func getPotassium() -> Int { return self.potassium}
    public func getCarbs() -> Int { return self.carbs}
    public func getFiber() -> Int { return self.fiber}
    public func getSugar() -> Int { return self.sugar}
    public func getComments() -> [Comment] { return self.comments}
    public func getIngredients() -> [(id:Int,ing:Ingredient, amount:Float)] { return self.ingredients}
    public func getDirections() -> [(id:Int, str:String)] { return self.directions}
    public func getRating() -> UIImage {return RatingImages[self.rating]}
    public func getFlags() -> Int{ return self.flags}
    public func getVitamins() -> [Vitamin] { return self.vitamin}
    /// Returns a dict of data for basic info
    public func getBasicInfo() -> [String: Int] {
        var result = [String: Int]()
        result["Calories"] = self.getCalories()
        result["Unsat. Fat"] = self.getUnsatFat()
        result["Sat. Fat"] = self.getSatFat()
        result["Cholesterol"] = self.getCholesterol();
        result["Sodium"] = self.getSodium()
        result["Potassium"] = self.getPotassium()
        result["Carbs"] = self.getCarbs()
        result["Fiber"] = self.getFiber()
        result["Sugar"] = self.getSugar()
        return result
    }
    /// Adds this recipe to the database
    public func addRecipe() -> Bool {

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
        
        let uid = String(currentUser.getId())
        print("UID: \(uid)")
        let name = self.name
        let photo = self.photo.getPath()
        let category = String(self.category)
        let servings = String(self.servings)
        let ptime = String(self.prepTime)
        let ctime = String(self.cookTime)
        let flags = String(self.flags)
        let calories = String(self.calories)
        let ufat = String(self.unsatFat)
        let sfat = String(self.satFat)
        let cholesterol = String(self.cholesterol)
        let sodium = String(self.sodium)
        let potassium = String(self.potassium)
        let carbs = String(self.carbs)
        let fiber = String(self.fiber)
        let sugar = String(self.sugar)
        
        let params = "uid=\(uid)&name=\(name)&photo=\(photo)&category=\(category)&servings=\(servings)&ptime=\(ptime)&ctime=\(ctime)&flags=\(flags)&calories=\(calories)&ufat=\(ufat)&sfat=\(sfat)&cholesterol=\(cholesterol)&sodium=\(sodium)&potassium=\(potassium)&carbs=\(carbs)&fiber=\(fiber)&sugar=\(sugar)"
        
        request.httpBody = params.data(using: String.Encoding.utf8)
        var recipeId = -1
        var eMsg = ""
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                eMsg = error!.localizedDescription
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
                    eMsg = parseJSON["msg"] as! String
                    vError = (parseJSON["error"] as! Bool)
                    recipeId = (parseJSON["code"] as! Int)
                }
            } catch {
                eMsg = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        if(!vError){
            // Add Recipe Directions
            for i in 0...(self.directions.count-1) {
                let result:(dError:Bool, errMsg:String) = AddDirections(rid:recipeId, num:i, str:directions[i].str)
                if(result.dError) {
                    print("Recipe::AddDirections(): \(result.errMsg)")
                }
            }
            // Add Recipe Vitamins
            for vitamin in self.vitamin {
                let result:(dError:Bool, errMsg:String) = vitamin.AddVitamin(rid: recipeId, idx: vitamin.getIndex(), percent: vitamin.getPercent())
                if(result.dError) {
                    print("Recipe::AddVitamin(): \(result.errMsg)")
                }
            }
            // Add Recipe Ingredients
            for ing in self.ingredients {
                let result:(dError:Bool, errMsg:String) = ing.ing.AddIngredient(rid: recipeId, iid: ing.id, amount: ing.amount)
                if(result.dError) {
                    print("Recipe::AddIngredient(): \(result.errMsg)")
                }
            }
        } else {
            print("Recipe::addRecipe(): \(eMsg)")
        }
        return vError
    }
    private func AddDirections(rid: Int, num:Int, str:String)-> (Bool, String) {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddRecipeDirection.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "rid=\(rid)&number=\(num)&description=\(str)"
        var eMsg = ""
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                eMsg = error!.localizedDescription
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
                    eMsg = parseJSON["msg"] as! String
                    print(eMsg)
                    vError = (parseJSON["error"] as! Bool)
                }
            } catch {
                eMsg = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        return (vError, eMsg)
    }
}
