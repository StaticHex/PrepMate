//
//  AddMealsViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 4/28/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

//Custom TableViewCell class that displays meal options
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
    
    var eMsg = ""
    var userRecipeList = [UserRecipe]() // Used for the recipe box and favorites list
    
    var recipeListBookmarks = [Recipe]()
    var recipeListFavorites = [Recipe]()
    
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
        self.getUserRecipes(uid: currentUser.getId())
        let tupleStrFavorites = ((0..<self.userRecipeList.count).filter({self.userRecipeList[$0].favorite == 1}).map{"\(self.userRecipeList[$0].recipeId!)"}).joined(separator: ", ")
        let tupleStrBookmarks = ((0..<self.userRecipeList.count).filter({self.userRecipeList[$0].favorite == 0}).map{"\(self.userRecipeList[$0].recipeId!)"}).joined(separator: ", ")
        var recipesFavorites = getRecipes(query: "id IN (\(tupleStrFavorites))")
        var recipeBookmarks = getRecipes(query: "id IN (\(tupleStrBookmarks))")
        
        self.recipeListBookmarks = recipeBookmarks
        self.recipeListFavorites = recipesFavorites
        self.mealsToChooseFrom = [MealOptions(name: "Recipe Box", items: self.recipeListBookmarks), MealOptions(name: "Favorites", items: self.recipeListFavorites)]
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

}
