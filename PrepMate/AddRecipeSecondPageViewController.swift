//
//  AddRecipeSecondPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol secondPageProtocol : class {
    func setRecipe(recipe: Recipe)
}

class VitaminCustomCell: UITableViewCell {
    @IBOutlet weak var vitaminName: UILabel!
    @IBOutlet weak var percentage: UILabel!
    
}

class AddRecipeSecondPageViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, addVitaminProtocol {

    // Outlets
    @IBOutlet weak var potassiumField: UITextField!
    @IBOutlet weak var cholesterolField: UITextField!
    @IBOutlet weak var carbField: UITextField!
    @IBOutlet weak var fiberField: UITextField!
    @IBOutlet weak var fatField: UITextField!
    @IBOutlet weak var caloriesField: UITextField!
    @IBOutlet weak var sodiumField: UITextField!
    @IBOutlet weak var sugarField: UITextField!
    
    @IBOutlet weak var vitaminTableView: UITableView!
    
    // List for maintaining display of vitamins
    var vitamins: [Vitamin] = [Vitamin]()
    
    // Recipe that will be saved if the user chooses to (will be passed from first add page controller)
    var recipeToSave: Recipe = Recipe()
    
    var addRecipeDelegate: secondPageProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vitaminTableView.delegate = self
        vitaminTableView.dataSource = self
        func back(sender: UIBarButtonItem) {
            print("Back Pressed!")
            let vc = self.navigationController?.popViewController(animated: true) as? AddRecipeFirstPageViewController
            vc?.recipeToSave = self.recipeToSave
            print("Saved Recipe")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        self.loadRecipe()
    }
    override func viewWillDisappear(_ animated: Bool) {
        // If user is returning to the first page
        if self.isMovingFromParentViewController {
            self.saveRecipe()
            self.addRecipeDelegate?.setRecipe(recipe: self.recipeToSave)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vitamins.count
    }
    /// Load any available recipe changes
    func loadRecipe() {
        if(self.recipeToSave.getCalories() != -1) {
            self.caloriesField.text! = "\(self.recipeToSave.getCalories())"
        }
        if(self.recipeToSave.getUnsatFat() != -1) {
            self.fatField.text! = "\(self.recipeToSave.getUnsatFat())"
        }
        if(self.recipeToSave.getCholesterol() != -1) {
            self.cholesterolField.text! = "\(self.recipeToSave.getCholesterol())"
        }
        if(self.recipeToSave.getSodium() != -1) {
            self.sodiumField.text! = "\(self.recipeToSave.getSodium())"
        }
        if(self.recipeToSave.getPotassium() != -1) {
            self.potassiumField.text! = "\(self.recipeToSave.getPotassium())"
        }
        if(self.recipeToSave.getSugar() != -1) {
            self.sugarField.text! = "\(self.recipeToSave.getSugar())"
        }
        if(self.recipeToSave.getCarbs() != -1) {
            self.carbField.text! = "\(self.recipeToSave.getCarbs())"
        }
        if(self.recipeToSave.getFiber() != -1) {
            self.fiberField.text! = "\(self.recipeToSave.getFiber())"
        }
        self.vitamins = self.recipeToSave.getVitamins()
    }
    /// Save recipe changes before returning to the first add recipe page
    func saveRecipe() {
        if Int(caloriesField.text!) != nil {
            self.recipeToSave.setCalories(calories: Int(caloriesField.text!)!)
        }
        
        if Int(fatField.text!) != nil {
            self.recipeToSave.setSatFat(satFat: Int(fatField.text!)!)
        }
        
        if Int(cholesterolField.text!) != nil {
            self.recipeToSave.setCholesterol(cholesterol: Int(cholesterolField.text!)!)
        }
        
        if Int(sodiumField.text!) != nil {
            self.recipeToSave.setSodium(sodium: Int(sodiumField.text!)!)
        }
        
        if Int(potassiumField.text!) != nil {
            self.recipeToSave.setPotassium(potassium: Int(potassiumField.text!)!)
        }
        
        if Int(sugarField.text!) != nil {
            self.recipeToSave.setSugar(sugar: Int(sugarField.text!)!)
        }
        
        if Int(carbField.text!) != nil {
            self.recipeToSave.setCarbs(carbs: Int(carbField.text!)!)
        }
        
        if Int(fiberField.text!) != nil {
            self.recipeToSave.setFiber(fiber: Int(fiberField.text!)!)
        }
        self.recipeToSave.setVitamin(vitamin: vitamins)
    }
    // Displaying information for a vitamin in the Vitamin table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vitaminTableCell", for: indexPath as IndexPath) as! VitaminCustomCell
        
        let row = indexPath.row
        cell.vitaminName.text = vitaminList[vitamins[row].getIndex()]
        cell.percentage.text = String(vitamins[row].getPercent()) + " %"
            
        return cell
    }
    
    // Information used for passing through the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addVitaminPopover" {
            let vc = segue.destination as? AddVitaminPopoverViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.addVitaminDelegate = self
            }
        }
    }
    
    // Function to add a vitamin for display on the Vitamin table view
    func addVitamin(vitamin: Vitamin) {
        vitamins.insert(vitamin, at: 0)
        self.vitaminTableView.beginUpdates()
        self.vitaminTableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        self.vitaminTableView.endUpdates()
    }
    
    // Receiving information about the recipe being created from the first page.
    func setRecipe(recipe: Recipe) {
        self.recipeToSave = recipe
    }
    
    // Save recipe.
    @IBAction func saveRecipe(_ sender: Any) {
        self.checkRecipe()
        self.recipeToSave.addRecipe()
    }
    /// Verifies that all fields have been filled
    func checkRecipe(){
        self.saveRecipe()
        if(self.recipeToSave.getName() == "") {
            self.recipeAlert(str: "Name")
            return
        }
        if(self.recipeToSave.getPrepTime() == -1) {
            self.recipeAlert(str: "Prep Time")
            return
        }
        if(self.recipeToSave.getCookTime() == -1) {
            self.recipeAlert(str: "Cook Time")
            return
        }
        if(self.recipeToSave.getCalories() == -1) {
            self.recipeAlert(str: "Calories")
            return
        }
        if(self.recipeToSave.getSatFat() == -1) {
            self.recipeAlert(str: "Fat")
            return
        }
        if(self.recipeToSave.getCholesterol() == -1) {
            self.recipeAlert(str: "Cholesterol")
            return
        }
        if(self.recipeToSave.getSodium() == -1) {
            self.recipeAlert(str: "Sodium")
            return
        }
        if(self.recipeToSave.getPotassium() == -1) {
            self.recipeAlert(str: "Potassium")
            return
        }
        if(self.recipeToSave.getCarbs() == -1) {
            self.recipeAlert(str: "Carbohydrate")
            return
        }
        if(self.recipeToSave.getFiber() == -1) {
            self.recipeAlert(str: "Fiber")
            return
        }
        if(self.recipeToSave.getSugar() == -1) {
            self.recipeAlert(str: "Sugar")
            return
        }
        if(self.recipeToSave.getIngredients().count == 0) {
            self.recipeAlert(str: "Ingredients")
            return
        }
        if(self.recipeToSave.getDirections().count == 0) {
            self.recipeAlert(str: "Directions")
            return
        }
        if(self.recipeToSave.getVitamins().count == 0) {
            self.recipeAlert(str: "Vitamins")
            return
        }
        
    }
    
    /// Helper function to alert recipe errors
    func recipeAlert(str:String) {
        let alert = UIAlertController(title: "Add Recipe Error", message: "\(str) field cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // User is sent back to the home page
    @IBAction func cancelRecipe(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomePageViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
}
