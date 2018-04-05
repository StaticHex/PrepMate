//
//  AddRecipeSecondPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol secondPageProtocol : class {
    func addVitamin(vitamin: Vitamin)
    func setRecipe(recipe: Recipe)
}

class VitaminCustomCell: UITableViewCell {
    @IBOutlet weak var vitaminName: UILabel!
    @IBOutlet weak var percentage: UILabel!
    
}

class AddRecipeSecondPageViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource,  secondPageProtocol {

    @IBOutlet weak var potassiumField: UITextField!
    @IBOutlet weak var cholesterolField: UITextField!
    @IBOutlet weak var carbField: UITextField!
    @IBOutlet weak var fiberField: UITextField!
    @IBOutlet weak var fatField: UITextField!
    @IBOutlet weak var caloriesField: UITextField!
    @IBOutlet weak var sodiumField: UITextField!
    @IBOutlet weak var sugarField: UITextField!
    
    @IBOutlet weak var vitaminTableView: UITableView!
    
    var vitamins: [Vitamin] = [Vitamin]()
    
    var recipeToSave: Recipe = Recipe()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vitaminTableView.delegate = self
        vitaminTableView.dataSource = self
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
    }
    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vitamins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vitaminTableCell", for: indexPath as IndexPath) as! VitaminCustomCell
        
        let row = indexPath.row
        cell.vitaminName.text = vitaminList[vitamins[row].getIndex()]
        cell.percentage.text = String(vitamins[row].getPercent()) + " %"
            
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addVitaminPopover" {
            let vc = segue.destination as? AddVitaminPopoverViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.secondDelegate = self
            }
        }
    }
    
    func addVitamin(vitamin: Vitamin) {
        vitamins.insert(vitamin, at: 0)
        self.vitaminTableView.beginUpdates()
        self.vitaminTableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        self.vitaminTableView.endUpdates()
    }
    
    func setRecipe(recipe: Recipe) {
        self.recipeToSave = recipe
    }
    
    @IBAction func saveRecipe(_ sender: Any) {
        
        if Int(caloriesField.text!) == nil {
            caloriesField.text = "Calories must be a number"
            return
        }
        self.recipeToSave.setCalories(calories: Int(caloriesField.text!)!)
        
        if Int(fatField.text!) == nil {
            fatField.text = "Fat must be a number"
            return
        }
        self.recipeToSave.setSatFat(satFat: Int(fatField.text!)!)
        
        if Int(cholesterolField.text!) == nil {
            cholesterolField.text = "Cholesterol must be a number"
            return
        }
        self.recipeToSave.setCholesterol(cholesterol: Int(cholesterolField.text!)!)
        
        if Int(sodiumField.text!) == nil {
            sodiumField.text = "Sodium must be a number"
            return
        }
        self.recipeToSave.setSodium(sodium: Int(sodiumField.text!)!)
        
        if Int(potassiumField.text!) == nil {
            potassiumField.text = "Potassium must be a number"
            return
        }
        self.recipeToSave.setPotassium(potassium: Int(potassiumField.text!)!)
        
        if Int(sugarField.text!) == nil {
            sugarField.text = "Sugar must be a number"
            return
        }
        self.recipeToSave.setSugar(sugar: Int(sugarField.text!)!)
        
        if Int(carbField.text!) == nil {
            carbField.text = "Carbohydrates must be a number"
            return
        }
        self.recipeToSave.setCarbs(carbs: Int(cholesterolField.text!)!)
        
        if Int(fiberField.text!) == nil {
            fiberField.text = "Fiber must be a number"
            return
        }
        self.recipeToSave.setFiber(fiber: Int(fiberField.text!)!)
        
        self.recipeToSave.setVitamin(vitamin: vitamins)
        
        self.recipeToSave.addRecipe()
    }
    
    @IBAction func cancelRecipe(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomePageViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
}
