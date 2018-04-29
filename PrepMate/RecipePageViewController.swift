//
//  RecipePageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class RecipePageViewController: UIViewController {
    var recipe = Recipe()
    @IBOutlet weak var RecipeOverviewView: UIView!
    @IBOutlet weak var RecipeNutritionView: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var RecipeCommentView: UIView!
    @IBOutlet weak var navBar: UINavigationItem!
    var isUser: Bool = false
    //var tintColor = UIColor.black
    @IBAction func onSegmentPressed(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){
            // Overview segment selected
            UIView.animate(withDuration: 0.5, animations: {
                self.RecipeOverviewView.alpha = 1
                self.RecipeNutritionView.alpha = 0
                self.RecipeCommentView.alpha = 0
                //self.navBar.rightBarButtonItem?.tintColor = self.tintColor
                self.navBar.rightBarButtonItem?.isEnabled = self.isUser
            })
        } else if(sender.selectedSegmentIndex == 1) {
            // Nutrition info segment selected
            UIView.animate(withDuration: 0.5, animations: {
                self.RecipeOverviewView.alpha = 0
                self.RecipeNutritionView.alpha = 1
                self.RecipeCommentView.alpha = 0
               // self.navBar.rightBarButtonItem?.tintColor = self.tintColor
                self.navBar.rightBarButtonItem?.isEnabled = self.isUser
                
            })
        } else {
            // Comment segment selected
            UIView.animate(withDuration: 0.5, animations: {
                self.RecipeOverviewView.alpha = 0
                self.RecipeNutritionView.alpha = 0
                self.RecipeCommentView.alpha = 1
                self.navBar.rightBarButtonItem?.tintColor = UIColor.clear
                self.navBar.rightBarButtonItem?.isEnabled = false
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navBar.title = self.recipe.getName()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
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
    
    @IBAction func onEditPressed(_ sender: Any) {
        print("EDIT PRESSED")
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
    }
    

}
