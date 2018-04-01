//
//  HistoryFavoriteSearchResultsViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit
/// Class for the tablecells on the Recipe Box page
class recipeBoxTableCell: UITableViewCell {
    /// Label that displays Recipe name
    @IBOutlet weak var recipeNameLabel: UILabel!
    /// Label that displays the rating for the recipe
    @IBOutlet weak var ratingsLabel: UIImageView!
    /// Function called when favorite button is pressed
    @IBAction func onFavoritePressed(_ sender: Any) {
        //TODO: Implement this
    }
    /// Function called when delete button is pressed
    @IBAction func onRemovePressed(_ sender: Any) {
        //TODO: Implement this
    }
    
}
class HistoryFavoriteSearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var histFavTableView: UITableView!
    /// Array containing the Recipes to show.
    var recipeList = [Recipe]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeBoxTableCell", for: indexPath as IndexPath) as! recipeBoxTableCell
        
        let row = indexPath.row
        cell.recipeNameLabel.text! = recipeList[row].getName()
        // TODO: How do we populate the rating?
        //cell.ratingsLabel.image =
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = false
        histFavTableView.delegate = self
        histFavTableView.dataSource = self
        let testComment = [Comment(id: 1, title: "TEST COMMENT", author: User(), rating: 1, description: "This is a test comment. Please work", date:NSDate())]
        let testIngredient = [(id:1, ing:Ingredient(id: 1, name: "Test", unit: 1, customLabel: "oz"), amount:Float(1.5))]
        let testVitamin = [Vitamin(id: 1, index: 1, percent: 0.5)]
        let testDirections = ["Test 1", "Test 2"]
        recipeList.append(Recipe(id: 1, name: "Test", photo: Photo(), category: 10, servings: 8, prepTime:10, cookTime:20, calories: 120, unsatFat: 20, satFat: 30, cholesterol: 30, sodium: 40, potassium: 50, carbs: 60, fiber: 70, sugar: 80, comments: testComment, ingredients: testIngredient, directions: testDirections, rating: 1, flags: 0, vitamin: testVitamin))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    /// Notifies viewController that a segue is about to performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "recipeBoxToRecipePage",
            let destination = segue.destination as? RecipePageViewController,
            let operatorIndex = histFavTableView.indexPathForSelectedRow?.row
        {
            destination.recipe = recipeList[operatorIndex]
        }
        
    }

}
