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
        self.loadRecipe()
        // Do any additional setup after loading the view.
    }
    /// Load the recipe overview information
    private func loadRecipe(){
        // TODO: Implement rating functionality
        //ratingsImage.image! = self.recipe.getRating()
        // TODO: uncomment this when actual recipe available
        //recipeImage.image! = self.recipe.getPhoto()
        ingredientText.text! = self.loadIngredients()
        directionsText.text! = self.loadDirections()
        caloriesLabel.text! = "Calories: \(self.recipe.getCalories())"
        servingsLabel.text! = "Servings: \(self.recipe.getServings())"
        fatLabel.text! = "Fat: \(self.recipe.getSatFat())"
        preptimeLabel.text! = "Prep: \(self.recipe.getPrepTime())"
        cooktimeLabel.text! = "Cook: \(self.recipe.getCookTime())"
        
    }
    /// Process the ingredients to be displayed as a String in the textview
    private func loadIngredients() -> String{
        let maxWidth = 20
        var result = String()
        for ingredient in self.recipe.getIngredients(){
            let tmp = ingredient.ing.getName().padding(toLength: maxWidth, withPad: " ", startingAt:0)
            result = result + String(format: "%@ %1.1f %@\n", tmp, ingredient.amount, ingredient.ing.getCustomLabel())
        }
        return result
    }
    /// Process the directions to be displayed as a String in the textview
    private func loadDirections() -> String {
        var result = String()
        var count = 1
        for direction in self.recipe.getDirections(){
            result = result + String(format: "%d. %@\n", count, direction)
            count = count + 1
        }
        return result
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
