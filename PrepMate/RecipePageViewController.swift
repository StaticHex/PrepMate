//
//  RecipePageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit
/// Recipe Page containing three subviews showing details about a specific recipe
class RecipePageViewController: UIViewController {
    /// Current recipe being shown
    var recipe = Recipe()
    /// Container view containing the recipe overview page
    @IBOutlet weak var RecipeOverviewView: UIView!
    /// Container view containing the recipe nutrition page
    @IBOutlet weak var RecipeNutritionView: UIView!
    /// Button to edit the current recipe
    @IBOutlet weak var editButton: UIBarButtonItem!
    /// Container view containing the recipe comment page
    @IBOutlet weak var RecipeCommentView: UIView!
    /// Outlet for the navigation bar
    @IBOutlet weak var navBar: UINavigationItem!
    /// Flag that keeps track of whether the current user is the creator of the recipe
    var isUser: Bool = false
    
    /// Function that controls which container view is shown based on the segmented control
    @IBAction func onSegmentPressed(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){
            // Overview segment selected
            UIView.animate(withDuration: 0.5, animations: {
                // Show the overview container view and hide all others
                self.RecipeOverviewView.alpha = 1
                self.RecipeNutritionView.alpha = 0
                self.RecipeCommentView.alpha = 0
                // Set the menu and text colors based on user preference
                let defaults = UserDefaults.standard
                if defaults.object(forKey: "navBarTextColor") != nil {
                    let decoded  = defaults.object(forKey: "navBarTextColor") as! Data
                    let decodedColor = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UIColor
                    self.navBar.rightBarButtonItem?.tintColor = decodedColor
                }
                else {
                    self.navBar.rightBarButtonItem?.tintColor = UIColor.blue
                }
                // Enabled the edit button if the current user created the current recipe
                self.navBar.rightBarButtonItem?.isEnabled = self.isUser
            })
        } else if(sender.selectedSegmentIndex == 1) {
            // Nutrition info segment selected
            
            // Set menu and text color preferences
            UIView.animate(withDuration: 0.5, animations: {
                self.RecipeOverviewView.alpha = 0
                self.RecipeNutritionView.alpha = 1
                self.RecipeCommentView.alpha = 0
                let defaults = UserDefaults.standard
                if defaults.object(forKey: "navBarTextColor") != nil {
                    let decoded  = defaults.object(forKey: "navBarTextColor") as! Data
                    let decodedColor = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UIColor
                    self.navBar.rightBarButtonItem?.tintColor = decodedColor
                }
                else {
                    self.navBar.rightBarButtonItem?.tintColor = UIColor.blue
                }
                // Enable the edit button if the current user created the current recipe
                self.navBar.rightBarButtonItem?.isEnabled = self.isUser
                
            })
        } else {
            // Comment segment selected
            UIView.animate(withDuration: 0.5, animations: {
                self.RecipeOverviewView.alpha = 0
                self.RecipeNutritionView.alpha = 0
                self.RecipeCommentView.alpha = 1
                // Hide the edit button as it is not intuitive when shown on comments page
                self.navBar.rightBarButtonItem?.tintColor = UIColor.clear
                self.navBar.rightBarButtonItem?.isEnabled = false
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the navigation bar title to the name of the recipe
        navBar.title = self.recipe.getName().capitalized
    }
    override func viewWillAppear(_ animated: Bool) {
        // Ensure that the navigation bar is visible
        navigationController?.isNavigationBarHidden = false
        // Check if the current user is the creator of the shown recipe
        if(currentUser.getId() == self.recipe.getCreatorId()){
            self.editButton.isEnabled = true
            isUser = true
        }else{
            self.editButton.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass Recipe to each of the container views
        if  segue.identifier == "recipePageToOverview",
            let destination = segue.destination as? RecipeOverviewViewController
        {
            destination.recipe = self.recipe
        }
        else if segue.identifier == "recipePageToNutrition",
            let destination = segue.destination as? RecipeNutritionViewController
        {
            destination.recipe = self.recipe
        }
        else if segue.identifier == "recipePageToComments",
            let destination = segue.destination as? RecipeCommentPageViewController
        {
            destination.recipe = self.recipe
        }
        else if segue.identifier == "editRecipeToAddRecipe" {
            // Prepare a recipe record if the recipe is about to be editted
            let vc = segue.destination as? AddRecipeFirstPageViewController
            vc?.recipeToSave = recipe.createRecord()
            vc?.recipeToUpdate = recipe
            vc?.fromEdit = true
        }
    }
    

}
