//
//  AddRecipeFirstPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol firstPageProtocol : class {
    func contains(containsItem: [Bool])
    func dietary(dietaryItem: [Bool])
    func addDirection(direction: String)
    func addIngredient(ingredient: Ingredient)
}

// Direction Table Custom Cell
class DirectionTableCell: UITableViewCell {
    @IBOutlet weak var directionLabel: UILabel!
}

// Ingredient Table Custom Cell
class IngredientTableCell: UITableViewCell {
    @IBOutlet weak var ingLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
}

class AddRecipeFirstPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverPresentationControllerDelegate, firstPageProtocol, secondPageProtocol {

    // Screen outlets
    @IBOutlet weak var recipeNameField: UITextField!
    @IBOutlet weak var prepTimeField: UITextField!
    @IBOutlet weak var cookTimeField: UITextField!
    @IBOutlet weak var directionTableview: UITableView!
    @IBOutlet weak var ingTableView: UITableView!
    @IBOutlet weak var categoryPickerTextField: UITextField!
    @IBOutlet weak var servingsSizeTextField: UITextField!
    
    // Information for both pickers on the screen (Serving size and Categories)
    var servingSizePicker = UIPickerView()
    var servingSizeOptions: [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
    var categoryPicker = UIPickerView()
    var categoryPickerOptions = [String]()
    
    var prepTimePicker = UIPickerView()
    var cookTimePicker = UIPickerView()
    var timeOptions: [[String]] = [["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"], [":"], ["00", "15", "30", "45"]]
    
    // Contains and Dietary bitvector
    var contains: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false]
    var dietary: [Bool] = [false, false, false, false, false, false, false]
    
    // List that is used to contain ingredients and directions for table view display
    var directionList = [String]()
    var ingList = [Ingredient]()
    var recipeToSave = Recipe()
    
    var directionCounter = 1
    
    weak var secondDelegate: secondPageProtocol?
    
    // Setting up screen display information
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        for c in categoryList {
            categoryPickerOptions.append(c.name)
        }
        
        directionTableview.delegate = self
        directionTableview.dataSource = self
        ingTableView.delegate = self
        ingTableView.dataSource = self
        
        self.servingSizePicker.delegate = self
        self.servingSizePicker.dataSource = self
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        self.prepTimePicker.delegate = self
        self.prepTimePicker.dataSource = self
        self.cookTimePicker.delegate = self
        self.cookTimePicker.dataSource = self

        servingsSizeTextField.inputView = servingSizePicker
        categoryPickerTextField.inputView = categoryPicker
        prepTimeField.inputView = prepTimePicker
        cookTimeField.inputView = cookTimePicker
        servingSizePicker.tag = 0
        categoryPicker.tag = 1
        prepTimePicker.tag = 2
        cookTimePicker.tag = 3
        servingsSizeTextField.text = String(servingSizeOptions[0])
        categoryPickerTextField.text = categoryPickerOptions[0]
        prepTimeField.text = timeOptions[0][0] + " hr(s)" +  timeOptions[1][0] + timeOptions[2][0] + " min(s)"
        cookTimeField.text = timeOptions[0][0] + " hr(s)" +  timeOptions[1][0] + timeOptions[2][0] + " min(s)"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 2 || pickerView.tag == 3 {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.directionTableview {
            return directionList.count
        }
        if tableView == self.ingTableView {
            return ingList.count
        }
        return -1
    }
    
    // Display different cell layouts depening which table is selected
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.directionTableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "directionTableCell", for: indexPath as IndexPath) as! DirectionTableCell
            
            let row = indexPath.row
            cell.directionLabel.text = String(directionCounter) + ". " + directionList[row]
            directionCounter += 1
            return cell
        }
        if tableView == self.ingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientTableCell", for: indexPath as IndexPath) as! IngredientTableCell
            
            let row = indexPath.row
            cell.amountLabel.text = String(ingList[row].getUnit()) + " " + ingList[row].getCustomLabel()
            cell.ingLabel.text = ingList[row].getName()
            
            return cell
            
        }
        return UITableViewCell()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return servingSizeOptions.count
        }
        else if pickerView.tag == 1 {
            return categoryPickerOptions.count
        }
        else {
            return timeOptions[component].count
        }
        
    }
    
    // Using a tag on which picker to choose to correctly display options
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return String(servingSizeOptions[row])
        }
        else if pickerView.tag == 1 {
            return categoryPickerOptions[row]
        }
        else {
            print(component)
            print(row)
            return timeOptions[component][row]
        }
    }
    
    // Using a tag on which picker to choose to correctly display options
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            servingsSizeTextField.text = String(servingSizeOptions[row])
        }
        else if pickerView.tag == 1 {
            categoryPickerTextField.text = categoryPickerOptions[row]
        }
        else if pickerView.tag == 2 {
            let hour = timeOptions[0][pickerView.selectedRow(inComponent: 0)]
            let min = timeOptions[2][pickerView.selectedRow(inComponent: 2)]
            prepTimeField.text = hour + " hr(s)" + timeOptions[1][0] + min + " min(s)"
        }
        else {
            let hour = timeOptions[0][pickerView.selectedRow(inComponent: 0)]
            let min = timeOptions[2][pickerView.selectedRow(inComponent: 2)]
            cookTimeField.text = hour + " hr(s)" + timeOptions[1][0] + min + " min(s)"
        }
        self.view.endEditing(true)
    }
    
    // Preparing info for delegation when passing through different segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstPageToContains" {
            let vc = segue.destination as? AddRecipeContainsPopoverViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.cDelegate = self
            }
        }
        else if segue.identifier == "firstPageToDietary" {
            let vc = segue.destination as? AddRecipeDietaryPageViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.dDelegate = self
            }
        }
        else if segue.identifier == "addIngredientSegue" {
            let vc = segue.destination as? AddIngredientViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.iDelegate = self
            }
        }
        else if segue.identifier == "addDirectionPopover" {
            let vc = segue.destination as? AddDirectionPopoverViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.dDelegate = self
            }
        }
        else if segue.identifier == "addRecipeFirstPageToSecond" {
            let vc = segue.destination as? AddRecipeSecondPageViewController
            vc?.recipeToSave = self.recipeToSave
            vc?.addRecipeDelegate = self
        }
    }
    
    // Contains bit vector passing from Contains popover
    func contains(containsItem: [Bool]) {
        self.contains = containsItem
    }
    
    
    // Dietary bit vector passing from Dietary popover
    func dietary(dietaryItem: [Bool]) {
        self.dietary = dietaryItem
    }
    // Protocol function to save recipe changes from second add recipe page
    func setRecipe(recipe: Recipe) {
        self.recipeToSave = recipe
    }
    
    // Function to add a direction to the direction table view. Non-DB yet
    func addDirection(direction: String) {
        directionList.insert(direction, at: 0)
        self.directionTableview.beginUpdates()
        self.directionTableview.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        self.directionTableview.endUpdates()
    }
    
    // Function to add an ingredient to the ingredient table view. Non-DB yet
    func addIngredient(ingredient: Ingredient) {
        ingList.insert(ingredient, at: 0)
        self.ingTableView.beginUpdates()
        self.ingTableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        self.ingTableView.endUpdates()
        
    }
    
    /// Helper function to alert recipe errors
    func recipeAlert(str:String) {
        let alert = UIAlertController(title: "Add Recipe Error", message: "\(str) field cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Build an incomplete recipe to pass to next view controller to finish
    @IBAction func nextPage(_ sender: Any) {

        // Name of the recipe
        if(recipeNameField.text! == "") {
            self.recipeAlert(str: "Name")
            return
        }
        
        if(ingList.count == 0) {
            self.recipeAlert(str: "Ingredients")
            return
        }
        
        if(directionList.count == 0) {
            self.recipeAlert(str: "Directions")
            return
        }

        // Recipe category
        recipeToSave.setCategory(category: categoryPickerOptions.index(of: categoryPickerTextField.text!)!)
        
        // Recipe servings
        recipeToSave.setServings(servings: servingSizeOptions.index(of: Int(servingsSizeTextField.text!)!)!)
        
        // Recipe preptime
        if Int(prepTimeField.text!) != nil {
            recipeToSave.setPrepTime(prepTime: Int(prepTimeField.text!)!)
        }

        // Recipe Cooktime
        if Int(cookTimeField.text!) != nil {
            recipeToSave.setCookTime(cookTime: Int(cookTimeField.text!)!)
        }

        // Go through each ingredient to add to the recipe
        let ingredientCells = self.ingTableView.visibleCells as! Array<IngredientTableCell>
        var ingredientInfo = [(id: Int, ing: Ingredient, amount: Float)]()
        // Need to grab ingredient and cell, so counter and cell made to keep track of where I am
        var counter = 0
        for cell in ingredientCells {
            let value = (cell.amountLabel.text?.components(separatedBy: " ").first)!
            ingredientInfo.append((id: -1, ing: ingList[counter], amount: Float(value)!))
            counter += 1
        }
        recipeToSave.setIngredients(ingredients: ingredientInfo)
        
        
        // Go through each direction to add to the recipe
        let directionCells = self.directionTableview.visibleCells as! Array<DirectionTableCell>
        var directionInfo = [(id: Int, str: String)]()
        // Need to grab direction and cell, so counter and cell made to keep track of where I am
        var directionCounter = 0
        for cell in directionCells {
            directionInfo.append((-1, cell.directionLabel.text!))
            directionCounter += 1
        }
        recipeToSave.setDirections(directions: directionInfo)
        
        // Setting up the bit vector for the recipe flags
        var flagVector = 0
        for c in 0...12 {
            if contains[c] {
                flagVector += 1
            }
            if c == 12 {
                break
            }
            flagVector <<= 1
        }
        for d in 0...6 {
            if dietary[d] {
                flagVector += 1
            }
            if d == 6 {
                break
            }
            flagVector <<= 1
        }
        recipeToSave.setFlags(flags: flagVector)
        
        //secondDelegate?.setRecipe(recipe: recipeToPass)
        
        self.performSegue(withIdentifier: "addRecipeFirstPageToSecond", sender: self)
        
        
    }
}
