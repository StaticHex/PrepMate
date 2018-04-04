//
//  AddRecipeFirstPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class DirectionTableCell: UITableViewCell {
    @IBOutlet weak var directionLabel: UILabel!
}

class IngredientTableCell: UITableViewCell {
    @IBOutlet weak var ingLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
}
class AddRecipeFirstPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var recipeNameField: UITextField!
    @IBOutlet weak var prepTimeField: UITextField!
    @IBOutlet weak var cookTimeField: UITextField!
    @IBOutlet weak var directionTableview: UITableView!
    @IBOutlet weak var ingTableView: UITableView!
    
    @IBOutlet weak var categoryPickerTextField: UITextField!
    @IBOutlet weak var servingsSizeTextField: UITextField!
    
    var servingSizePicker = UIPickerView()
    var servingSizeOptions: [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
    
    var categoryPicker = UIPickerView()
    var categoryPickerOptions: [String] = ["American", "Asian", "Latin", "etc."]
    
    
    var directionList = [String]()
    var ingList = [Ingredient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = false
        
        self.servingSizePicker.delegate = self
        self.servingSizePicker.dataSource = self
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self

        servingsSizeTextField.inputView = servingSizePicker
        servingSizePicker.tag = 0
        categoryPickerTextField.inputView = categoryPicker
        categoryPicker.tag = 1
        servingsSizeTextField.text = String(servingSizeOptions[0])
        categoryPickerTextField.text = categoryPickerOptions[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.directionTableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "directionTableCell", for: indexPath as IndexPath) as! DirectionTableCell
            return cell
        }
        if tableView == self.ingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientTableCell", for: indexPath as IndexPath) as! IngredientTableCell
            return cell
            
        }
        return UITableViewCell()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return servingSizeOptions.count
        }
        else {
            return categoryPickerOptions.count
        }
        
    }
    
    // Got off tutorial
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return String(servingSizeOptions[row])
        }
        else {
            return categoryPickerOptions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            servingsSizeTextField.text = String(servingSizeOptions[row])
        }
        else {
            categoryPickerTextField.text = categoryPickerOptions[row]
        }
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstPageToContains" {
            
        }
    }
}
