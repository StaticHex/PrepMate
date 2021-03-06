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
    @IBOutlet weak var btnRemove: UIButton!
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

// User recipe struct
// container object to avoid tuples because re-typing fields is terrible
struct UserRecipe {
    var id : Int?
    var recipeId : Int?
    var recipeName : String?
    var recipeRating : Int?
    var favorite : Int?
}

struct mealRecipe {
    var recipe:Recipe?
    var mealRecipeId: Int?
}

class HistoryFavoriteSearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, recipeBoxProtocol, mealsProtocol {
    func removeMealCell(cell: MealsCustomTableViewCell) {
        ///Shouldn't be called ever
        return
    }
    
    // Populating display with recipes of a meal that a user selected
    func addFromSelectedMeals(meal: Meal) {
        self.meal = meal
        self.fromMeal = true
        let tmp = self.meal.getMealRecipes()
        self.recipeList = tmp.recipe
        self.mealRecipeList = tmp.mIds
        self.histFavTableView.reloadData()
    }
    
    
    // RecipeBox and Favorite list variables
    var userRecipeList = [UserRecipe]() // Used for the recipe box and favorites list
    var eMsg = "" // holds error message returned by recipe list functions
    
    @IBOutlet weak var AddButton: UIButton!
    
    @IBOutlet weak var cookButton: UIButton!
    @IBOutlet weak var histFavTableView: UITableView!
    /// Array containing the Recipes to show.
    var recipeList = [Recipe]()
    var mealRecipeList = [Int]()
    var meal = Meal()
    var fromMeal = false
    var row : Int?
    
    // 0 myRecipe, 1 removeRecipe
    var whichRecipeClicked = -1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = false
        histFavTableView.delegate = self
        histFavTableView.dataSource = self
        if(fromMeal){
            AddButton.isHidden = false
            cookButton.isHidden = false
        }else {
            AddButton.isHidden = true
            cookButton.isHidden = true
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(!fromMeal){
            getUserRecipes(uid: currentUser.getId())
        }
        
        // Only display unique recipes rather than allow duplicates to be shown
        var list = [UserRecipe]()
        if whichRecipeClicked == 0 {
            list = userRecipeList.filter {$0.favorite == 0}
        }
        else if whichRecipeClicked == 2 {
            list = userRecipeList.filter {$0.favorite == 1}
        }
        if whichRecipeClicked == 0 || whichRecipeClicked == 2 {
            var unique = [Int]()
            var uniqueRecipes = [UserRecipe]()
            for item in list {
                if !unique.contains(item.recipeId!) {
                    unique.append(item.recipeId!)
                    uniqueRecipes.append(item)
                }
            }
            userRecipeList = uniqueRecipes
        }
        print("AT END: \(whichRecipeClicked)")
        histFavTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if whichRecipeClicked == 0 || whichRecipeClicked == 2 {
            return userRecipeList.count
        }
        else {
            return recipeList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeBoxTableCell", for: indexPath as IndexPath) as! recipeBoxTableCell
        
        let row = indexPath.row
        cell.rBProtocol = self
        cell.ratingsLabel.contentMode = .scaleAspectFit

        if whichRecipeClicked == 0 || whichRecipeClicked == 2 {
            cell.recipeNameLabel.text! = userRecipeList[row].recipeName!
            cell.ratingsLabel.image = RatingImages[userRecipeList[row].recipeRating!]
            cell.row = row
            cell.favoriteSelect.isEnabled = false
            cell.favoriteSelect.isHidden = true
        }
        else {
            if(whichRecipeClicked == 3) {
                cell.favoriteSelect.isEnabled = false
                cell.favoriteSelect.isHidden = true
                cell.btnRemove.isEnabled = false
                cell.btnRemove.isHidden = true
            }
            cell.recipeNameLabel.text! = recipeList[row].getName()
            cell.ratingsLabel.image = RatingImages[recipeList[row].getRating()]
            cell.row = row
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            if whichRecipeClicked == 0  || whichRecipeClicked == 2 {
                let dest = getRecipes(query: "id=\(userRecipeList[operatorIndex].recipeId!)")
                print(dest)
                destination.recipe = dest[0]
            }
            else {
                destination.recipe = recipeList[operatorIndex]
            }
        }
        else if segue.identifier == "addMealRecipeSegue",
           let destination = segue.destination as? AddMealsViewController
            {
                destination.mProtocol = self
                destination.meal = self.meal
                destination.existingMeal = true
            }
        
    }
    
    // Alert that checks if a user wants to cook a meal
    @IBAction func onCook(_ sender: Any) {
        let alert = UIAlertController(title: "Cook Meal", message: "Are you sure you want to cook this meal?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .default, handler: { _ in
            if(self.meal.cookMeal()){
                self.databaseAlert(str: "Cook Meal error")
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Default action"), style: .default, handler: { _ in
            print("No Pressed")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Remove a user saved recipe from the display and the database
    func removeRecipe(cell: recipeBoxTableCell) {
        // Favorited or bookmarked recipe to delete
        if whichRecipeClicked == 0 || whichRecipeClicked == 2 {
            // Remove from recipes saved for this user
            let userRecipeToDelete = userRecipeList[cell.row]
            
            let success = removeUserRecipe(idx: cell.row)
            if success {
                self.databaseAlert(str: "Remove User Recipe")
            }
            else {
                self.histFavTableView.reloadData()
                return
            }
        }
        else if whichRecipeClicked == 1 {
            // Remove a recipe from the database that the user has created
            let recipeToDelete = recipeList[cell.row]
            
            let success = recipeToDelete.removeRecipe()
            if success {
                self.databaseAlert(str: "Remove Recipe")
            }
            else {
                self.histFavTableView.reloadData()
                return
            }
        }else{
            if(fromMeal){
                // Remove a recipe from a meal
                let success = removeMealRecipe(idx: cell.row)
                if success {
                    self.databaseAlert(str: "Remove Meal Recipe")
                    print("\(self.meal.eMsg)")
                } else {
                    self.histFavTableView.reloadData()
                    return
                }
                
            }
        }

    }
    
    // Database alert to display to the user if a database function did not execute correctly
    func databaseAlert(str:String) {
        let alert = UIAlertController(title: "\(str)", message: "Database Error", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occurred.")
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // Functions for dealing with user recipes (should be keeping a list of these for recipe box and favorites)
    func addUserRecipe(newRecipe :UserRecipe) -> Bool {
        // create mutable object out of parameter
        var uRecipe = newRecipe
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddUserRecipe.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // Set up parameters

        
        // Create HTTP Body
        let params = "uid=\(currentUser.getId())&rid=\(newRecipe.recipeId!)&favorite=\(newRecipe.favorite!)"
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                self.eMsg = error!.localizedDescription
                finished = true
                vError = true
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    self.eMsg = parseJSON["msg"] as! String
                    vError = (parseJSON["error"] as! Bool)
                    if(!vError) {
                        if let sId = parseJSON["id"] as? String {
                            uRecipe.id = Int(sId)!
                            if let rRating = parseJSON["recipe_rating"] as? String {
                                uRecipe.recipeRating = Int(rRating)!
                                if let rName = parseJSON["recipe_name"] as? String {
                                    uRecipe.recipeName = rName
                                } else {
                                    uRecipe.recipeName = "ERROR"
                                    vError = true
                                    self.eMsg = "error occured while parsing recipe name from add operation"
                                }
                            } else {
                                uRecipe.recipeRating = 0
                                vError = true
                                self.eMsg = "error occured while parsing recipe rating from add operation"
                            }
                        } else {
                            uRecipe.id = -1
                            vError = true
                            self.eMsg = "error occured while parsing user recipe ID from add operation"
                            return
                        }
                    }
                }
            } catch {
                self.eMsg = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        if(!vError) {
            self.userRecipeList.append(uRecipe)
        }
        return vError
    }
    
    // Update a user recipe
    func updateUserRecipe(idx : Int) -> Bool {
        // grab the index to write to the database
        let newRecipe = userRecipeList[idx]
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/UpdateUserRecipe.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // Set up parameters
        
        
        // Create HTTP Body
        let params = "id=\(newRecipe.id!)&uid=\(currentUser.getId())&rid=\(newRecipe.recipeId!)&favorite=\(newRecipe.favorite!)"
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                self.eMsg = error!.localizedDescription
                finished = true
                vError = true
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    self.eMsg = parseJSON["msg"] as! String
                    vError = (parseJSON["error"] as! Bool)
                }
            } catch {
                self.eMsg = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        return vError
    }
    
    // Get recipes that the user has saved (favorited or bookmarked)
    func getUserRecipes(uid:Int) -> Bool {
        // reset the list
        self.userRecipeList.removeAll()
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/GetUserRecipes.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "id=\(uid)"
        
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                self.eMsg = error!.localizedDescription
                finished = true
                vError = true
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    vError = (parseJSON["error"] as! Bool)
                    self.eMsg = parseJSON["msg"] as! String
                    if(!vError) {
                        var count = 0
                        while let record = parseJSON["\(count)"] as? String {
                            if let row = try JSONSerialization.jsonObject(with: record.data(using: String.Encoding.utf8)!, options: .mutableContainers) as? NSDictionary {
                                var current = UserRecipe()
                                if let urId = row["id"] as? String {
                                    current.id = Int(urId)!
                                    if let urRid = row["recipe_id"] as? String {
                                        current.recipeId = Int(urRid)!
                                        if let urRName = row["recipe_name"] as? String {
                                            current.recipeName = urRName
                                            if let urRating = row["recipe_rating"] as? String {
                                                current.recipeRating = Int(urRating)!
                                                if let urFav = row["favorite"] as? String {
                                                    current.favorite = Int(urFav)!
                                                    self.userRecipeList.append(current)
                                                } else {
                                                    vError = true
                                                    self.eMsg = "Error occured while parsing user recipe favorite in get user recipes"
                                                    return
                                                }
                                            } else {
                                                vError = true
                                                self.eMsg = "Error occured while parsing recipe rating in get user recipes"
                                                return
                                            }
                                        } else {
                                            vError = true
                                            self.eMsg = "Error occured while parsing recipe name in get user recipes"
                                            return
                                        }
                                    } else {
                                        vError = true
                                        self.eMsg = "Error occured while parsing recipe id in get user recipes"
                                        return
                                    }
                                } else {
                                    vError = true
                                    self.eMsg = "Error occured while parsing user recipe id in get user recipes"
                                    return
                                }
                            }
                            count += 1
                        }
                    }
                }
            } catch {
                self.eMsg = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        return vError
    }
    
    // Remove a saved recipe from a user's list (Favorited or bookmarked)
    func removeUserRecipe(idx:Int) -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/RemoveUserRecipe.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let params = "id="+String(userRecipeList[idx].id!)
        
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                self.eMsg = error!.localizedDescription
                finished = true
                vError = true
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    self.eMsg = parseJSON["msg"] as! String
                    vError = (parseJSON["error"] as! Bool)
                }
            } catch {
                self.eMsg = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        
        // Wipe recipe entry
        if(!vError) {
            userRecipeList.remove(at: idx)
        }
        return vError
    }
    
    // Remove a recipe from a meal
    func removeMealRecipe(idx: Int) -> Bool{
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/RemoveMealRecipe.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "id=\(mealRecipeList[idx])"
        
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                self.eMsg = error!.localizedDescription
                finished = true
                vError = true
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    self.eMsg = parseJSON["msg"] as! String
                    vError = (parseJSON["error"] as! Bool)
                }
            } catch {
                self.eMsg = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        // Wipe entries
        if(!vError) {
            recipeList.remove(at: idx)
            mealRecipeList.remove(at: idx)
        }
        return vError
    }
}
