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
    func addFromSelectedMeals(recipe: Recipe)
}


class MealsPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, mealsProtocol {
    
    

    
    var meals = [Recipe]()

    
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
        navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mealsToRecipeBoxSegue" {
            let vc = segue.destination as? HistoryFavoriteSearchResultsViewController
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
        cell.mealName.text = meals[row].getName()
        
        return cell
    }
    
    func addFromSelectedMeals(recipe: Recipe) {
        meals.append(recipe)
        self.mealsTableView.beginUpdates()
        self.mealsTableView.insertRows(at: [IndexPath.init(row: meals.count - 1, section: 0)], with: .automatic)
        self.mealsTableView.endUpdates()
    }
    
    func removeMeal(cell: MealsCustomTableViewCell) {
        let indexPath = self.mealsTableView.indexPath(for: cell)
        meals.remove(at: indexPath!.row)
        self.mealsTableView.deleteRows(at: [indexPath!], with: .fade)
    }
    
    
    @IBAction func addMealToShoppingList(_ sender: Any) {
        
        // Go through rows, which are selected, then add to shopping list (first checking if we need to make new row in shopping list or just adding an amount)
    }
    @IBAction func addMeal(_ sender: Any) {
        self.performSegue(withIdentifier: "addMealSegue", sender: sender)
    }
}
