//
//  MealsPageViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol mealsProtocol : class {
    func removeMealCell(cell: MealsCustomTableViewCell)
    func addFromSelectedMeals(meal: Meal)
}


class MealsPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, mealsProtocol {
    
    
    var meals = [Meal]()

    
    @IBOutlet weak var mealsTableView: UITableView!
    @IBOutlet weak var checkoutCart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = false
        mealsTableView.delegate = self
        mealsTableView.dataSource = self
        self.meals = getMeals()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        let defaults = UserDefaults.standard
        
        // Do not show checkout cart if the user does not have shopping list auto manage on
        if let decoded = defaults.object(forKey: "amSList") as? Data {
            let status = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Bool
            if !status {
                self.checkoutCart.isHidden = true
                self.checkoutCart.isEnabled = false
            }
        }
    }    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mealsToRecipeBoxSegue",
            let operatorIndex = self.mealsTableView.indexPathForSelectedRow?.row,
            let vc = segue.destination as? HistoryFavoriteSearchResultsViewController
        {
            let tmp = meals[operatorIndex].getMealRecipes()
            vc.recipeList = tmp.recipe
            vc.mealRecipeList = tmp.mIds
            vc.fromMeal = true
            vc.meal = meals[operatorIndex]
        }
        else if segue.identifier == "addingMealsToRecipeBox" {
            let vc = segue.destination as? HistoryFavoriteSearchResultsViewController
        }
        if segue.identifier == "addMealSegue" {
            let vc = segue.destination as? AddMealsViewController
            vc?.mProtocol = self
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MealsCustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "mealsTableCell", for: indexPath as IndexPath) as! MealsCustomTableViewCell
        
        cell.mProtocol = self
        let row = indexPath.row
        cell.mealName.text = meals[row].name.capitalized
        let defaults = UserDefaults.standard
        
        // Do not show if the user can select a meal for checkout if the auto manage shopping list is not on.
        if let decoded = defaults.object(forKey: "amSList") as? Data {
            let status = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Bool
            if !status {
                cell.selectedItem.isHidden = true
                cell.selectedItem.isEnabled = false
            }
        }
        return cell
    }
    
    func addFromSelectedMeals(meal:Meal) {
        self.meals = getMeals()
        self.mealsTableView.reloadData()
    }
    
    // Remove a cell from the table view
    func removeMealCell(cell: MealsCustomTableViewCell) {
        let indexPath = self.mealsTableView.indexPath(for: cell)
        if(removeMeal(id: self.meals[indexPath!.row].mealId)){
            print("Error removing meal")
        } else {
            self.meals = getMeals()
            self.mealsTableView.reloadData()
        }
    }
    
    
    // Add a meal to the user's shopping list
    @IBAction func addMealToShoppingList(_ sender: Any) {
        
        // Go through rows, which are selected, then add to shopping list (first checking if we need to make new row in shopping list or just adding an amount)
        let selected = (0..<mealsTableView.numberOfRows(inSection: 0)).filter({(mealsTableView.cellForRow(at: IndexPath.init(row: $0, section: 0)) as! MealsCustomTableViewCell).selectedItem.currentTitle == "■"})
        shoppingListAlert(arg:selected)
        
        
    }
    @IBAction func addMeal(_ sender: Any) {
        self.performSegue(withIdentifier: "addMealSegue", sender: sender)
    }
    
    // Alert to confirm that a user wants to add their selected meals to the shopping list
    func shoppingListAlert(arg:[Int]) {
        let alert = UIAlertController(title: "Meal to Shopping List", message: "Are you sure you want to add selected meals to the shopping list?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .default, handler: { _ in
            for item in arg {
                if(self.meals[item].mealToSL()){
                    print(self.meals[item].eMsg)
                }
                (self.mealsTableView.cellForRow(at: IndexPath.init(row: item, section: 0)) as! MealsCustomTableViewCell).selectedItem.setTitle("□", for: .normal)
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Default action"), style: .default, handler: { _ in
            print("No Pressed")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
