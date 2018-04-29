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
        
    }
    @IBAction func onAddPressed(_ sender: Any) {
        
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
    


}
