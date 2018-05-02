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
    func addIngredient(ingredient: RecipeIngredient)
    func removeIngredient(cell: IngredientTableCell)
    func removeDirection(cell: DirectionTableCell)
}

// Direction Table Custom Cell
class DirectionTableCell: UITableViewCell {
    @IBOutlet weak var directionLabel: UILabel!
    
    weak var cellProtocol : firstPageProtocol?
    
    @IBAction func removeDirection(_ sender: Any) {
        cellProtocol?.removeDirection(cell: self)
    }
}

// Ingredient Table Custom Cell
class IngredientTableCell: UITableViewCell {
    
    weak var cellProtocol : firstPageProtocol?
    
    @IBOutlet weak var ingLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBAction func removeIngredient(_ sender: Any) {
        cellProtocol?.removeIngredient(cell: self)
    }
    
    
}

class AddRecipeFirstPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverPresentationControllerDelegate, firstPageProtocol, secondPageProtocol, AddIngredientProtocol {

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
    var servingSizeOptions: [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
    var categoryPicker = UIPickerView()
    var categoryPickerOptions = [String]()
    
    var prepTimePicker = UIPickerView()
    var cookTimePicker = UIPickerView()
    var timeOptions: [[String]] = [["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"], [":"], ["00", "15", "30", "45"]]
    
    // Contains and Dietary bitvector
    var contains: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false]
    var dietary: [Bool] = [false, false, false, false, false, false, false]
    
    // List that is used to contain ingredients and directions for table view display
    var directionList = [String]()
    var ingList = [RecipeIngredient]()
    var recipeToSave = RecipeRecord()
    
    var prepTimeHour: String = "00"
    var prepTimeMin: String = "00"
    var cookTimeHour: String = "00"
    var cookTimeMin: String = "00"
    
    var fromEdit = false
    
    // pass recipe record
    var recipeToUpdate : Recipe?
    
    weak var secondDelegate: secondPageProtocol?
    
    // Setting up screen display information
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        for c in categoryList {
            categoryPickerOptions.append(c)
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
        if recipeToSave.name != "" {
            recipeNameField.text = recipeToSave.name.capitalized
            ingList = recipeToSave.ingredients
            for item in recipeToSave.directions {
                print(item.description)
                directionList.append(item.description)
            }
            self.ingTableView.reloadData()
            self.directionTableview.reloadData()
            servingsSizeTextField.text = "\(recipeToSave.servings)"
            categoryPickerTextField.text = categoryList[recipeToSave.category]
            var cookTime = recipeToSave.cookTime.components(separatedBy: ":")
            var prepTime = recipeToSave.prepTime.components(separatedBy: ":")
            prepTimeHour = "\(prepTime[0])"
            prepTimeMin = "\(prepTime[1])"
            cookTimeHour = "\(cookTime[0])"
            cookTimeMin = "\(cookTime[1])"
            prepTimeField.text = prepTime[0] + " hr(s)" +  timeOptions[1][0] + prepTime[1] + " min(s)"
            cookTimeField.text = cookTime[0] + " hr(s)" +  timeOptions[1][0] + cookTime[1] + " min(s)"
            
            // Do flags
//            for i in (0...(nutritionImages.count-1)).reversed(){
//                if (flagNum & 1 ) == 1 {
//                    self.nutritionList.append(nutritionImages[i])
//                }
//                flagNum = flagNum >> 1
//            }
            var flagNum = self.recipeToSave.flags
            for d in (0...6).reversed() {
                if (flagNum & 1 ) == 1 {
                    print("Dietary True at \(d)")
                    dietaryVector[d] = true
                }
                flagNum = flagNum >> 1
            }
            for c in (0...12).reversed() {
                if (flagNum & 1 ) == 1 {
                    print("Contains true at \(c)")
                    containsVector[c] = true
                }
                flagNum = flagNum >> 1
            }
            
            
            
        }
        else {
            servingsSizeTextField.text = String(servingSizeOptions[0])
            categoryPickerTextField.text = categoryPickerOptions[0]
            prepTimeField.text = timeOptions[0][0] + " hr(s)" +  timeOptions[1][0] + timeOptions[2][0] + " min(s)"
            cookTimeField.text = timeOptions[0][0] + " hr(s)" +  timeOptions[1][0] + timeOptions[2][0] + " min(s)"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("\n\n\nGOT HERE!!!\n\n")
        print(recipeToSave)
        print("\n\n")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        if self.isMovingFromParentViewController {
            // Remove saved data from Contains and Dietary popovers
            for c in 0...(containsVector.count-1) {
                containsVector[c] = false
            }
            for d in 0...(dietaryVector.count-1) {
                dietaryVector[d] = false
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func removeIngredient(cell: IngredientTableCell) {
        let indexPath = self.ingTableView.indexPath(for: cell)
        ingList.remove(at: indexPath!.row)
        self.ingTableView.deleteRows(at: [indexPath!], with: .fade)
    }
    
    func removeDirection(cell: DirectionTableCell) {
        let indexPath = self.directionTableview.indexPath(for: cell)
        directionList.remove(at: indexPath!.row)
        self.directionTableview.deleteRows(at: [indexPath!], with: .fade)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Display different cell layouts depening which table is selected
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.directionTableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "directionTableCell", for: indexPath as IndexPath) as! DirectionTableCell
            
            let row = indexPath.row
            cell.cellProtocol = self
            cell.directionLabel.text = "\(directionList[row])"
            return cell
        }
        if tableView == self.ingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientTableCell", for: indexPath as IndexPath) as! IngredientTableCell
            
            let row = indexPath.row
            
            cell.cellProtocol = self
            
            let defaults = UserDefaults.standard
            
            let idx = ingList[row].item.getUnit()
            // Standard
            
            if defaults.integer(forKey: "units") == 0 {
                let valToDisplay = metricToStd(unit: ingList[row].item.getUnit(), amount: ingList[row].amount)
                if ingList[row].item.getLabel() != "" {
                    if fromEdit {
                        var found = false
                        for i in 0...recipeToSave.ingredients.count-1 {
                            if recipeToSave.ingredients[i].id == ingList[row].id {
                                found = true
                            }
                        }
                        if found {
                            cell.amountLabel.text = String(format: "%1.2f %@\n", ingList[row].amount, ingList[row].item.getLabel())
                        }
                        else {
                            cell.amountLabel.text = String(format: "%1.2f %@\n", valToDisplay, ingList[row].item.getLabel())
                        }

                    }
                    else {
                        cell.amountLabel.text = String(format: "%1.2f %@\n", valToDisplay, ingList[row].item.getLabel())
                    }
                }
                else {
                    if fromEdit {
                        var found = false
                        for i in 0...recipeToSave.ingredients.count-1 {
                            if recipeToSave.ingredients[i].id == ingList[row].id {
                                found = true
                            }
                        }
                        if found {
                            cell.amountLabel.text = String(format: "%1.2f %@\n", ingList[row].amount, unitList[ingList[row].item.getUnit()].std)
                        }
                        else {
                            cell.amountLabel.text = String(format: "%1.2f %@\n", valToDisplay, unitList[ingList[row].item.getUnit()].std)
                        }
//                        cell.amountLabel.text = String(format: "%1.1f %@\n", ingList[row].amount, unitList[ingList[row].item.getUnit()].std)
                    }
                    else {
                        cell.amountLabel.text = String(format: "%1.2f %@\n", valToDisplay, unitList[ingList[row].item.getUnit()].std)
                    }
                }
            }
            else {
                if ingList[row].item.getLabel() != "" {
                    cell.amountLabel.text = String(format: "%1.2f %@\n", ingList[row].amount, ingList[row].item.getLabel())
                }
                else {
                    cell.amountLabel.text = String(format: "%1.2f %@\n", ingList[row].amount, unitList[ingList[row].item.getUnit()].metric)
                }
            }

            cell.ingLabel.text = ingList[row].item.getName()
            
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
            prepTimeHour = hour
            prepTimeMin = min
            prepTimeField.text = hour + " hr(s)" + timeOptions[1][0] + min + " min(s)"
        }
        else {
            let hour = timeOptions[0][pickerView.selectedRow(inComponent: 0)]
            let min = timeOptions[2][pickerView.selectedRow(inComponent: 2)]
            cookTimeHour = hour
            cookTimeMin = min
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
                vc?.addIngredientDelegate = self
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
            vc?.addRecipeDelegate = self
            vc?.recipeToSave = self.recipeToSave
            if fromEdit {
                vc?.recipeToUpdate = recipeToUpdate!
                vc?.fromEdit = true
            }

        }
    }
    
    // Contains bit vector passing from Contains popover
    func contains(containsItem: [Bool]) {
        self.contains = containsItem
    }
    
    func addReturnedIngredient(ingredient: RecipeIngredient) {
        // TODO: ADD INGREDIENT CODE HERE
        addIngredient(ingredient: ingredient)
        print(ingredient.item)
        print(ingredient.amount)
    }
    
    // Dietary bit vector passing from Dietary popover
    func dietary(dietaryItem: [Bool]) {
        self.dietary = dietaryItem
    }
    // Protocol function to save recipe changes from second add recipe page
    func setRecipe(recipe: RecipeRecord) {
        self.recipeToSave = recipe
    }
    
    // Function to add a direction to the direction table view. Non-DB yet
    func addDirection(direction: String) {
        directionList.append(direction)
        self.directionTableview.beginUpdates()
        self.directionTableview.insertRows(at: [IndexPath.init(row: directionList.count-1, section: 0)], with: .automatic)
        self.directionTableview.endUpdates()
    }
    
    // Function to add an ingredient to the ingredient table view. Non-DB yet
    func addIngredient(ingredient: RecipeIngredient) {
        ingList.append(ingredient)
        self.ingTableView.beginUpdates()
        self.ingTableView.insertRows(at: [IndexPath.init(row: ingList.count-1, section: 0)], with: .automatic)
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

        if  cookTimeField.text == "00 hr(s):00 min(s)" {
            self.recipeAlert(str: "Cook Time")
        }
        
        if  prepTimeField.text == "00 hr(s):00 min(s)" {
            self.recipeAlert(str: "Prep Time")
        }
        
        recipeToSave.name = recipeNameField.text!
        
        // Recipe category
        recipeToSave.category = categoryPickerOptions.index(of: categoryPickerTextField.text!)!
        
        // Recipe servings
        recipeToSave.servings = "\(servingSizeOptions.index(of: servingsSizeTextField.text!)!)"
        
        // Recipe preptime
        recipeToSave.prepTime = (prepTimeHour + ":" + prepTimeMin + ":00")

        // Recipe Cooktime
        recipeToSave.cookTime = (cookTimeHour + ":" + cookTimeMin + ":00")

        // Go through each ingredient to add to the recipe
        let ingredientCells = self.ingTableView.visibleCells as! Array<IngredientTableCell>
        var ingredientInfo = [RecipeIngredient]()
        // Need to grab ingredient and cell, so counter and cell made to keep track of where I am
        var counter = 0
        for cell in ingredientCells {
            let value = (cell.amountLabel.text?.components(separatedBy: " ").first)!
            var ing = RecipeIngredient()
                ing.item = ingList[counter].item
                ing.amount = Double(value)!
            
            ingredientInfo.append(ing)
            counter += 1
        }
        recipeToSave.ingredients = ingredientInfo
        
        
        // Go through each direction to add to the recipe
        let directionCells = self.directionTableview.visibleCells as! Array<DirectionTableCell>
        var directionInfo = [Direction]()
        // Need to grab direction and cell, so counter and cell made to keep track of where I am

        for cell in directionCells {
            var dir = Direction()
            dir.description = cell.directionLabel.text!
            directionInfo.append(dir)
        }

        recipeToSave.directions = directionInfo
        
        // Setting up the bit vector for the recipe flags
        var flagVector = 0
        for c in 0...12 {
            if contains[c] {
                flagVector += 1
            }
//            if c == 12 {
//                break
//            }
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
        recipeToSave.flags = flagVector
        recipeToSave.creatorId = currentUser.getId()
        recipeToSave.servings = servingsSizeTextField.text!
        secondDelegate?.setRecipe(recipe: recipeToSave)
        
        self.performSegue(withIdentifier: "addRecipeFirstPageToSecond", sender: self)
        
        
    }
}
