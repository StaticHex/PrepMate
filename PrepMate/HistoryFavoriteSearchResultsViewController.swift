//
//  HistoryFavoriteSearchResultsViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol recipeBoxProtocol : class {
    func removeRecipe(cell: recipeBoxTableCell)
}

/// Class for the tablecells on the Recipe Box page
class recipeBoxTableCell: UITableViewCell {
    /// Label that displays Recipe name
    @IBOutlet weak var recipeNameLabel: UILabel!
    /// Label that displays the rating for the recipe
    @IBOutlet weak var ratingsLabel: UIImageView!
    @IBOutlet weak var favoriteSelect: UIButton!
    weak var rBProtocol : recipeBoxProtocol?
    
    var row = 0
    /// Function called when favorite button is pressed
    @IBAction func onFavoritePressed(_ sender: Any) {
        //TODO: Implement this
        
    }
    /// Function called when delete button is pressed
    @IBAction func onRemovePressed(_ sender: Any) {
        //TODO: Implement this
        
        rBProtocol?.removeRecipe(cell: self)
    }
    
}
class HistoryFavoriteSearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, recipeBoxProtocol {
    
    
    @IBOutlet weak var histFavTableView: UITableView!
    /// Array containing the Recipes to show.
    var recipeList = [Recipe]()
    
    var row : Int?
    
    // 0 myRecipe, 1 removeRecipe
    var whichRecipeClicked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = false
        histFavTableView.delegate = self
        histFavTableView.dataSource = self
        /*
         v
         var testRecipe = RecipeRecord()
         testRecipe.name = "Test"
         testRecipe.photo = "https://media1.popsugar-assets.com/files/thumbor/D0OYajmdcatHUC1-b4Axbf-uNxo/fit-in/2048xorig/filters:format_auto-!!-:strip_icc-!!-/2017/02/08/859/n/1922195/a7a42800589b73af54eda9.99423697_edit_img_image_43136859_1486581354/i/KFC-Fried-Chicken-Pizza.jpg"
         testRecipe.category = 10
         testRecipe.creatorId = currentUser.getId()
         testRecipe.servings = "6~8"
         testRecipe.prepTime = "00:10:00"
         testRecipe.cookTime = "00:10:00"
         testRecipe.calories = 120
         testRecipe.unsatFat = 20
         testRecipe.satFat = 30
         testRecipe.cholesterol = 30
         testRecipe.sodium = 40
         testRecipe.potassium = 50
         testRecipe.carbs = 60
         testRecipe.fiber = 70
         testRecipe.sugar = 80
         
         var ingredient = RecipeIngredient()
         if(ingredient.item.getIngredient(iid: 8)) {
         print(ingredient)
         }
         ingredient.amount = 6
         
         testRecipe.ingredients.append((ingredient))
         
         var vitamin = Vitamin()
         vitamin.idx = 1
         vitamin.percent = 0.5
         
         testRecipe.vitamins.append(vitamin)
         
         var direction = Direction()
         direction.description = "Test 1"
         
         testRecipe.directions.append(direction)
         
         var direction2 = Direction()
         direction2.description = "Test 2"
         
         testRecipe.directions.append(direction2)
         
         let recipe = Recipe()
         if(recipe.addRecipe(newRecipe: testRecipe)) {
         print(recipe)
         }
         
         var comment = Comment()
         comment.title = "TEST COMMENT"
         comment.rating = 1
         comment.description = "This is a test comment. Please work"
         
         if(recipe.addRecipeComment(newComment: comment)) {
         print(recipe)
         }
         
         var rList = [21,22,48]
         for r in rList {
         var recipe = Recipe()
         recipe.getRecipe(rid: r)
         recipeList.append(recipe)
         }*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeBoxTableCell", for: indexPath as IndexPath) as! recipeBoxTableCell
        
        let row = indexPath.row
        cell.rBProtocol = self
        cell.recipeNameLabel.text! = recipeList[row].getName()
        cell.ratingsLabel.image = RatingImages[recipeList[row].getRating()]
        cell.row = row
        if whichRecipeClicked == 1 {
            cell.favoriteSelect.isEnabled = false
            cell.favoriteSelect.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        histFavTableView.reloadData()
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
    
    func removeRecipe(cell: recipeBoxTableCell) {
        if whichRecipeClicked == 0 {
            // Remove from recipes saved for this user
        }
        else if whichRecipeClicked == 1 {
            // Remove recipe from DB
            let recipeToDelete = recipeList[cell.row]
            let success = recipeToDelete.removeRecipe()
            if success {
                self.databaseAlert(str: "Database Error")
            }
            else {
                return
            }
        }
        
        let indexPath = self.histFavTableView.indexPath(for: cell)
        recipeList.remove(at: indexPath!.row)
        self.histFavTableView.deleteRows(at: [indexPath!], with: .fade)
    }
    
    func databaseAlert(str:String) {
        let alert = UIAlertController(title: "Add Recipe Error", message: "\(str)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
