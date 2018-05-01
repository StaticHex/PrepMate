//
//  RecipeOverviewViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit
import Foundation

class RecipeOverviewViewController: UIViewController {

    /// When Favorite button is pressed
    @IBAction func onFavoritePressed(_ sender: Any) {
        var userRecipe = UserRecipe(id: currentUser.getId(), recipeId: recipe.getId(), recipeName: recipe.getName(), recipeRating: recipe.getRating(), favorite: 1)
        addUserRecipe(newRecipe: userRecipe)
    }
    @IBAction func onAddPressed(_ sender: Any) {
        var userRecipe = UserRecipe(id: currentUser.getId(), recipeId: recipe.getId(), recipeName: recipe.getName(), recipeRating: recipe.getRating(), favorite: 0)
        addUserRecipe(newRecipe: userRecipe)
    }
    
    @IBAction func onCreatorButton(_ sender: Any) {
        
    }
    @IBOutlet weak var creatorButton: UIButton!
    @IBOutlet weak var ratingsImage: UIImageView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientText: UITextView!
    @IBOutlet weak var directionsText: UITextView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var preptimeLabel: UILabel!
    @IBOutlet weak var cooktimeLabel: UILabel!
    var recipe = Recipe()
    
    var userRecipeList = [UserRecipe]() // Used for the recipe box and favorites list
    var eMsg = "" // holds error message returned by recipe list functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredientText.layer.borderWidth = 1
        self.directionsText.layer.borderWidth = 1
        self.recipeImage.contentMode = .scaleAspectFit
        self.ratingsImage.contentMode = .scaleAspectFit
        self.loadRecipe()
        let creator = User()
        creator.getUser(uid: self.recipe.getCreatorId())
        self.creatorButton.setTitle(creator.getUname(), for: .normal)
        // Do any additional setup after loading the view.
    }
    /// Load the recipe overview information
    private func loadRecipe(){
        
        ratingsImage.image = RatingImages[self.recipe.getRating()]
        recipeImage.image = self.recipe.getPhoto()
        ingredientText.text! = self.loadIngredients()
        directionsText.text! = self.loadDirections()
        caloriesLabel.text! = "Calories: \(self.recipe.getCalories().amount)"
        servingsLabel.text! = "Servings: \(self.recipe.getServings())"
        fatLabel.text! = "Fat: \(self.recipe.getSatFatG().amount)"
        preptimeLabel.text! = "Prep: \(self.recipe.getPrepTime())"
        cooktimeLabel.text! = "Cook: \(self.recipe.getCookTime())"
        
    }
    /// Process the ingredients to be displayed as a String in the textview
    private func loadIngredients() -> String{
        let maxWidth = 20
        var result = String()
        for i in 0..<self.recipe.getNumIngredients(){
            let ingredient = self.recipe.getRecipeIngredient(idx: i)
            print(ingredient.item)
            let tmp = ingredient.item.getName().padding(toLength: maxWidth, withPad: " ", startingAt:0)
            let defaults = UserDefaults.standard
            if defaults.integer(forKey: "units") == 0 {
                if ingredient.item.getLabel() != "" {
                    result = result + String(format: "%@ %1.1f %@\n", tmp, ingredient.amount, ingredient.item.getLabel())
                }
                else {
                    result = result + String(format: "%@ %1.1f %@\n", tmp, ingredient.amount, unitList[ingredient.item.getUnit()].std)
                }
            }
            else {
                if ingredient.item.getLabel() != "" {
                    result = result + String(format: "%@ %1.1f %@\n", tmp, ingredient.amount, ingredient.item.getLabel())
                }
                else {
                    result = result + String(format: "%@ %1.1f %@\n", tmp, ingredient.amount, unitList[ingredient.item.getUnit()].metric)
                }
            }
        }
        return result
    }
    /// Process the directions to be displayed as a String in the textview
    private func loadDirections() -> String {
        var result = String()
        var count = 1
        for i in 0..<self.recipe.getNumDirections(){
            var direction = self.recipe.getRecipeDirection(idx: i)
            result = result + String(format: "%d. %@\n", count, direction.description)
            count = count + 1
        }
        return result
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Functions for dealing with user recipes (should be keeping a list of these for recipe box and favorites)
    func addUserRecipe(newRecipe :UserRecipe) -> Bool {
        // create mutable object out of parameter
        var uRecipe = newRecipe
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddUserRecipe.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // Set up parameters
        
        
        // Create HTTP Body
        let params = "uid=\(currentUser.getId())&rid=\(newRecipe.recipeId!)&favorite=\(newRecipe.favorite!)"
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
                        if let sId = parseJSON["id"] as? Int {
                            uRecipe.id = sId
                            if let rRating = parseJSON["recipe_rating"] as? String {
                                uRecipe.recipeRating = Int(rRating)!
                                if let rName = parseJSON["recipe_name"] as? String {
                                    uRecipe.recipeName = rName
                                } else {
                                    uRecipe.recipeName = "ERROR"
                                    vError = true
                                    self.eMsg = "error occured while parsing recipe name from add operation"
                                }
                            } else {
                                uRecipe.recipeRating = 0
                                vError = true
                                self.eMsg = "error occured while parsing recipe rating from add operation"
                            }
                        } else {
                            uRecipe.id = -1
                            vError = true
                            self.eMsg = "error occured while parsing user recipe ID from add operation"
                            return
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
        if(!vError) {
            self.userRecipeList.append(uRecipe)
        }
        return vError
    }
    


}
