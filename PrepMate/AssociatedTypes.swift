//
//  AssociatedTypes.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 4/4/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation
import UIKit

// Selections for outlet displays that users will have on their screens
public let nutritionImages = [#imageLiteral(resourceName: "f0.png"), #imageLiteral(resourceName: "f1.png"), #imageLiteral(resourceName: "f1.png"), #imageLiteral(resourceName: "f3.png"), #imageLiteral(resourceName: "f4.png"), #imageLiteral(resourceName: "f5.png"), #imageLiteral(resourceName: "f6.png"), #imageLiteral(resourceName: "f7.png"), #imageLiteral(resourceName: "f8.png"), #imageLiteral(resourceName: "f9.png"), #imageLiteral(resourceName: "f10.png"), #imageLiteral(resourceName: "f11.png"), #imageLiteral(resourceName: "f12.png"), #imageLiteral(resourceName: "f13.png"), #imageLiteral(resourceName: "f14.png"), #imageLiteral(resourceName: "f15.png"), #imageLiteral(resourceName: "f16.png"), #imageLiteral(resourceName: "f17.png"), #imageLiteral(resourceName: "f18.png"), #imageLiteral(resourceName: "f19.png")]
public let RatingImages = [#imageLiteral(resourceName: "r0.png"), #imageLiteral(resourceName: "r1.png"), #imageLiteral(resourceName: "r2.png"), #imageLiteral(resourceName: "r3.png"), #imageLiteral(resourceName: "r4.png"), #imageLiteral(resourceName: "r5.png"), #imageLiteral(resourceName: "r6.png"), #imageLiteral(resourceName: "r7.png"), #imageLiteral(resourceName: "r8.png"), #imageLiteral(resourceName: "r9.png"), #imageLiteral(resourceName: "r10.png")]
public let categoryImages = [#imageLiteral(resourceName: "c0.png"),#imageLiteral(resourceName: "c1.png"),#imageLiteral(resourceName: "c2.png"),#imageLiteral(resourceName: "c3.png"),#imageLiteral(resourceName: "c4.png"),#imageLiteral(resourceName: "c5.png"),#imageLiteral(resourceName: "c6.png"),#imageLiteral(resourceName: "c7.png"),#imageLiteral(resourceName: "c8.png"),#imageLiteral(resourceName: "c9.png"),#imageLiteral(resourceName: "c10.png"),#imageLiteral(resourceName: "c11.png"),#imageLiteral(resourceName: "c12.png"),#imageLiteral(resourceName: "c13.png"),#imageLiteral(resourceName: "c14.png"),#imageLiteral(resourceName: "c15.png"),#imageLiteral(resourceName: "c16.png"),#imageLiteral(resourceName: "c17.png"),#imageLiteral(resourceName: "c18.png"),#imageLiteral(resourceName: "c19.png"),#imageLiteral(resourceName: "c20.png"),
                             #imageLiteral(resourceName: "c21.png"),#imageLiteral(resourceName: "c22.png"),#imageLiteral(resourceName: "c23.png"),#imageLiteral(resourceName: "c24.png"),#imageLiteral(resourceName: "c25.png"),#imageLiteral(resourceName: "c26.png"),#imageLiteral(resourceName: "c27.png"),#imageLiteral(resourceName: "c28.png"),#imageLiteral(resourceName: "c29.png"),#imageLiteral(resourceName: "c30.png"),#imageLiteral(resourceName: "c31.png"),#imageLiteral(resourceName: "c32.png"),#imageLiteral(resourceName: "c33.png"),#imageLiteral(resourceName: "c34.png"),#imageLiteral(resourceName: "c35.png"),#imageLiteral(resourceName: "c36.png"),#imageLiteral(resourceName: "c37.png"),#imageLiteral(resourceName: "c38.png"),#imageLiteral(resourceName: "c39.png"),#imageLiteral(resourceName: "c40.png"),#imageLiteral(resourceName: "c41.png"),
                             #imageLiteral(resourceName: "c42.png"),#imageLiteral(resourceName: "c43.png"),#imageLiteral(resourceName: "c44.png"),#imageLiteral(resourceName: "c45.png"),#imageLiteral(resourceName: "c46.png"),#imageLiteral(resourceName: "c47.png")]
public let vitaminList = ["Vitamin A", "Calcium", "Vitamin B-12", "Vitamin C", "Iron", "Vitamin B-6", "Magnesium"]

public let categoryList = ["African",
                           "American",
                           "Argentine",
                           "Bangladeshi",
                           "Brazilian",
                           "Burmese",
                           "Canadian",
                           "Chilean",
                           "Chinese",
                           "Ecuadorian",
                           "English",
                           "Ethiopian",
                           "French",
                           "German",
                           "Greek",
                           "Hungarian",
                           "Indian",
                           "Indonesian",
                           "Irish",
                           "Israeli",
                           "Italian",
                           "Jamaican",
                           "Japanese",
                           "Korean",
                           "North Korean",
                           "Malaysian",
                           "Maltese",
                           "Mexican",
                           "Moroccan",
                           "Nepalese",
                           "Pakistani",
                           "Palestinian",
                           "Peruvian",
                           "Philippine",
                           "Polish",
                           "Portuguese",
                           "Russian",
                           "Sami",
                           "Scottish",
                           "Sicilian",
                           "Singaporean",
                           "South African",
                           "Spanish",
                           "Sri Lankan",
                           "Thai",
                           "Tibetan",
                           "Uzbek",
                           "Vietnamese"]

public let ingredientList = [(flag: 1, name: "Tree Nuts", field: "has_tree_nuts"),
                             (flag: 2, name: "Eggs", field: "has_eggs"),
                             (flag: 4, name: "Milk", field: "has_milk"),
                             (flag: 8, name: "Gluten", field: "has_gluten"),
                             (flag: 16, name: "Meat", field: "has_meat"),
                             (flag: 32, name: "Pork", field: "has_pork"),
                             (flag: 64, name: "Butter", field: "has_butter"),
                             (flag: 128, name: "Peanuts", field: "has_peanuts"),
                             (flag: 256, name: "Shellfish", field: "has_shellfish"),
                             (flag: 512, name: "Tomatoes", field: "has_tomatoes"),
                             (flag: 1024, name: "Soy", field: "has_soy"),
                             (flag: 2048, name: "Fish", field: "has_fish"),
                             (flag: 4096, name: "Yeast", field: "has_yeast")]

public let foodTypeList = [(flag: 8192, name: "Spicy", field: "is_spicy"),
                           (flag: 16384, name: "Healthy", field: "is_healthy"),
                           (flag: 32768, name: "High Fat", field: "is_high_fat"),
                           (flag: 65536, name: "Vegetarian", field: "is_vegetarian"),
                           (flag: 131072, name: "Vegan", field: "is_vegan")]

// divide metric amount by factor to get standard amount
public let unitList = [(std: "custom", metric: "custom", factor: 1.0),
                        (std: "tsp", metric: "ml", factor: 5.0),
                        (std: "tbsp", metric: "ml", factor: 15.0),
                        (std: "fl oz", metric: "ml", factor: 30.0),
                        (std: "cup", metric: "ml", factor: 240.0),
                        (std: "pint", metric: "ml", factor: 480.0),
                        (std: "quart", metric: "ml", factor: 960.0),
                        (std: "oz", metric: "g", factor: 30.0),
                        (std: "lb", metric: "g", factor: 480.0),
                        (std: "in", metric: "cm", factor: 2.5)]


public func metricToStd(unit:Int, amount:Double) -> Double {
    return amount / unitList[unit].factor
}

public func stdToMetric(unit:Int, amount:Double) -> Double {
    return amount * unitList[unit].factor
}
public func getTimestamp() -> String {
    let date = Date()
    let calendar = Calendar.current
    var tsString = ""
    tsString += calendar.component(.month, from: date).description + "/"
    tsString += calendar.component(.day, from: date).description + "/"
    tsString += calendar.component(.year, from: date).description + " "
    var hour = Int(calendar.component(.hour, from: date).description)!
    var suffix = "AM"
    if(hour > 11) {
        suffix = "PM"
    }
    if(hour > 12) {
        hour -= 12
    }
    if(hour == 0) {
        hour = 12
    }
    tsString += String(hour) + ":"
    tsString += calendar.component(.minute, from: date).description+suffix
    return tsString
}

public var recipeEMsg = ""

func getMeals() -> [Meal] {
    var meals = [Meal]()
    
    // path to our backend script
    let URL_VERIFY = "http://www.teragentech.net/prepmate/GetMeals.php"
    
    var mealEMsg: String = ""
    
    // variable which will spin until verification is finished
    var finished : Bool = false
    
    // create our URL object
    let url = URL(string: URL_VERIFY)
    
    // create the request and set the type to POST, otherwise we get authorization error
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    let params = "uid=\(currentUser.getId())"
    
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
                            let newMeal = Meal()
                            newMeal.creatorId = currentUser.getId()
                            
                            if let rid = entry["id"] as? String {
                                newMeal.mealId = Int(rid)!
                            } else {
                                print("getMeals(): Populate function errored while parsing id")
                            }
                            if let name = entry["name"] as? String {
                                newMeal.name = name
                            } else {
                                print("getMeals(): Populate function errored while parsing name")
                            }
                            meals.append(newMeal)
                            count+=1
                        }
                    }
                } else {
                    meals.removeAll()
                    print(mealEMsg)
                    return
                }
            }
        } catch {
            mealEMsg = error.localizedDescription
            print(mealEMsg)
            meals.removeAll()
            return
        }
        finished = true
    }
    // execute our task and then return the results
    task.resume()
    while(!finished) {}

    return meals
}

func getRecipes(query:String) -> [Recipe] {
    var recipes = [Recipe]()
    
    // path to our backend script
    let URL_VERIFY = "http://www.teragentech.net/prepmate/GetRecipes.php"
    
    // variable which will spin until verification is finished
    var finished : Bool = false
    
    // create our URL object
    let url = URL(string: URL_VERIFY)
    
    // create the request and set the type to POST, otherwise we get authorization error
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    let params = "query=\(query)"
    
    request.httpBody = params.data(using: String.Encoding.utf8)
    
    // Create a task and send our request to our REST API
    let task = URLSession.shared.dataTask(with: request) {
        data, response, error in
        // if we error out, return the error message
        if(error != nil) {
            recipeEMsg = error!.localizedDescription
            finished = true
            recipes.removeAll()
            return
        }
        
        // If there was no error, parse the response
        do {
            // convert response to a dictionary
            let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
            
            // Get the error status and the error message from the database
            if let parseJSON = JSONResponse {
                recipeEMsg = parseJSON["msg"] as! String
                let vError = (parseJSON["error"] as! Bool)
                if(!vError) {
                    var count = 0
                    while let record = parseJSON[String(count)] as? NSString {
                        if let entry = try JSONSerialization.jsonObject(with: record.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                            
                            let newRecipe = Recipe()
                            if(!newRecipe.populateFromDict(query: entry)) {
                                recipes.append(newRecipe)
                            } else {
                                print(newRecipe.getEMsg())
                            }
                            count+=1
                        }
                    }
                } else {
                    recipes.removeAll()
                    return
                }
            }
        } catch {
            recipeEMsg = error.localizedDescription
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
public func removeMeal(id:Int)->Bool {
    // create a variable to return whether we errored out or not
    var vError : Bool = false
    var eMsg = ""
    // path to our backend script
    let URL_VERIFY = "http://www.teragentech.net/prepmate/RemoveMeal.php"
    
    // variable which will spin until verification is finished
    var finished : Bool = false
    
    // create our URL object
    let url = URL(string: URL_VERIFY)
    
    // create the request and set the type to POST, otherwise we get authorization error
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    let params = "id=\(id)"
    
    request.httpBody = params.data(using: String.Encoding.utf8)
    
    // Create a task and send our request to our REST API
    let task = URLSession.shared.dataTask(with: request) {
        data, response, error in
        // if we error out, return the error message
        if(error != nil) {
            eMsg = error!.localizedDescription
            finished = true
            print(eMsg)
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
            }
        } catch {
            eMsg = error.localizedDescription
            vError = true
            print(eMsg)
        }
        finished = true
    }
    // execute our task and then return the results
    task.resume()
    while(!finished) {}
    return vError
}

// A substring function because apple depreciated theirs
func substring(tok: String, begin : Int, end : Int) -> String {
    if begin < 0 || end < 0 {
        return ""
    }
    if begin >= end {
        return ""
    }
    var count : Int = 0
    let tokArray = Array(tok)
    var retStr : String = ""
    for c in tokArray {
        if count >= begin && count < end {
            retStr += String(c)
        }
        count += 1
    }
    
    return retStr
}

// Holds information for the currently logged in user, was used on so many screens we
// moved it here
var currentUser = User()

// used to keep fetching recipes dialog to popping up every time user return from home
var firstRun = false

