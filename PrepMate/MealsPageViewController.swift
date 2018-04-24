//
//  MealsPageViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol mealsProtocol : class {
    func removeMeal(cell: MealsCustomTableViewCell)
}

var meals = [Recipe]()

class MealsPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, mealsProtocol {

    @IBOutlet weak var mealsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = false
        mealsTableView.delegate = self
        mealsTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mealsToRecipeBoxSegue" {
            let vc = segue.destination as? HistoryFavoriteSearchResultsViewController
        }
        else if segue.identifier == "addingMealsToRecipeBox" {
            let vc = segue.destination as? HistoryFavoriteSearchResultsViewController
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MealsCustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "mealsTableCell", for: indexPath as IndexPath) as! MealsCustomTableViewCell
        
        cell.mProtocol = self
        
        let row = indexPath.row
        cell.mealName.text = meals[row].getName()
        
        return cell
    }
    
    func removeMeal(cell: MealsCustomTableViewCell) {
        let indexPath = self.mealsTableView.indexPath(for: cell)
        meals.remove(at: indexPath!.row)
        self.mealsTableView.deleteRows(at: [indexPath!], with: .fade)
    }

    @IBAction func addMeal(_ sender: Any) {
        
        // UNNECESSARY?
        self.performSegue(withIdentifier: "addingMealsToRecipeBox", sender: sender)
    }
    
    @IBAction func addMealOption(_ sender: Any) {
        /*let meal = Recipe(id: 1, name: "recipeAdded", photo: Photo(), category: 1, servings: 1, prepTime: "00:00:00", cookTime: "00:00:00", calories: 1, unsatFat: 1, satFat: 1, cholesterol: 1, sodium: 1, potassium: 1, carbs: 1, fiber: 1, sugar: 1, comments: [Comment](), ingredients: [(id:Int,ing:Ingredient, amount:Float)](), directions: [(id: -1, str: "Dummy")], rating: 1, flags: 1, vitamin: [Vitamin]())
        
                meals.append(meal)
                self.mealsTableView.beginUpdates()
                self.mealsTableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                self.mealsTableView.endUpdates()
//        self.performSegue(withIdentifier: "addingMealsToRecipeBox", sender: sender)*/
    }
    
    @IBAction func addMealToShoppingList(_ sender: Any) {
        
        // Go through rows, which are selected, then add to shopping list (first checking if we need to make new row in shopping list or just adding an amount)
    }
}
