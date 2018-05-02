//
//  AddMealsViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 4/28/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit


class MealsOptionsCustomCell: UITableViewCell {
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var selectedItem: UIButton!
    var section = 0
    var row = 0
    
    @IBAction func selectItem(_ sender: Any) {
        
        var title = ""
        if selectedItem.currentTitle == "■" {
            if section == 0 {
                mealsChosenRecipeBox[row] = false
            }
            else {
                mealsChosenFavorites[row] = false
            }
            title = "□"
        }
        else {
            if section == 1 {
                mealsChosenRecipeBox[row] = true
            }
            else {
                mealsChosenFavorites[row] = true
            }
            title = "■"
        }
        
        // No animation on button click
        UIView.performWithoutAnimation {
            self.selectedItem.setTitle(title, for: .normal)
            self.selectedItem.layoutIfNeeded()
        }
        
    }
    
}

struct MealOptions {
    let name : String
    var items : [Recipe]
}

var mealsChosenRecipeBox = [Bool]()
var mealsChosenFavorites = [Bool]()

class AddMealsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mealsTableView: UITableView!
    @IBOutlet weak var mealNameInput: UITextField!

    weak var mProtocol : mealsProtocol?
    
    var mealsToChooseFrom = [MealOptions]()
    var meal = Meal()
    
    var recipeList = getRecipes(query: "id>=1 ORDER BY rating ASC LIMIT 10")
    
    var existingMeal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        mealsTableView.delegate = self
        mealsTableView.dataSource = self
        if(existingMeal){
            self.mealNameInput.text = self.meal.name
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mealsToChooseFrom = [MealOptions(name: "Recipe Box", items: self.recipeList), MealOptions(name: "Favorites", items: self.recipeList)]
        mealsChosenRecipeBox = [Bool](repeating: false, count: mealsToChooseFrom[0].items.count)
        mealsChosenFavorites = [Bool](repeating: false, count: mealsToChooseFrom[1].items.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mealsToChooseFrom.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.mealsToChooseFrom[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = self.mealsToChooseFrom[section].items
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell") as! MealsOptionsCustomCell
        let row = indexPath.row
        let items = self.mealsToChooseFrom[indexPath.section].items
        let recipe = items[row]
        cell.recipeName.text = recipe.getName()
        cell.section = indexPath.section
        cell.row = row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func saveMeal(_ sender: Any) {
        if(mealNameInput.text! == "") {
            self.mealAlert(str: "Meal Name")
            return
        }
        var recipeList = [Recipe]()
        for row in 0..<mealsChosenRecipeBox.count {
            if mealsChosenRecipeBox[row] {
                recipeList.append(mealsToChooseFrom[0].items[row])
            }
        }
        for row in 0..<mealsChosenFavorites.count {
            if mealsChosenFavorites[row] {
               recipeList.append(mealsToChooseFrom[1].items[row])
            }
        }
        if(recipeList.count == 0){
            self.mealAlert(str: "Selected recipes")
            return
        }
        var meal = Meal()
        if(existingMeal){
            meal = self.meal
        } else {
            if(meal.addMeal(uid:currentUser.getId(), name: mealNameInput.text!)){
                print("ADD MEAL FAILED: ")
                print(meal.eMsg)
            }
        }
        
        for recipe in recipeList {
            print("Adding Recipe: \(recipe.getName()) with id: \(recipe.getId())")
            if(meal.addMealRecipe(rid: recipe.getId())){
                print("ADD MEAL RECIPE FAILED: ");
                print(meal.eMsg)
            }
        }
        mProtocol?.addFromSelectedMeals(meal: meal)
        
        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    /// Helper function to alert meal errors
    func mealAlert(str:String) {
        let alert = UIAlertController(title: "Add Meal Error", message: "\(str) cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }


}
