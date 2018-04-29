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
            title = "□"
        }
        else {
            if section == 0 {
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
    
    var recipeList = getRecipes(query: "id>=1 ORDER BY rating ASC LIMIT 10")
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        mealsTableView.delegate = self
        mealsTableView.dataSource = self
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
            self.recipeAlert(str: "Meal Name")
            return
        }
        
        for row in 0..<mealsChosenRecipeBox.count {
            if mealsChosenRecipeBox[row] {
                mProtocol?.addFromSelectedMeals(recipe: mealsToChooseFrom[0].items[row])
            }
        }
        for row in 0..<mealsChosenFavorites.count {
            if mealsChosenFavorites[row] {
                mProtocol?.addFromSelectedMeals(recipe: mealsToChooseFrom[1].items[row])
            }
        }
        
        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    /// Helper function to alert recipe errors
    func recipeAlert(str:String) {
        let alert = UIAlertController(title: "Add Recipe Error", message: "\(str) field cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
