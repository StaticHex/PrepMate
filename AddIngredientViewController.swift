//
//  AddIngredientViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 4/4/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class AddIngredientViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // Outlets
    @IBOutlet weak var itemTextView: UITextField!
    @IBOutlet weak var amountTextView: UITextField!
    @IBOutlet weak var amountPickerTextView: UITextField!
    @IBOutlet weak var tvAutoComp: UITableView!
    
    @IBOutlet weak var pickerText: UITextField!
    
    var whichController : Int = 0
    
    weak var sDelegate : shoppingListProtocol?
    weak var iDelegate : firstPageProtocol?
    weak var pDelegate : pantryProtocol?
    
    // Picker information
    var unitPicker = UIPickerView()
    var stdPickerOptions = ["custom", "tsp", "tbsp", "fl. oz", "cup", "pint", "quart", "oz", "lb", "in"]
    var metricPickerOptions = ["custom", "ml", "g", "cm"]
    var currentUnits = 0
    
    // Setting up the display on the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        self.unitPicker.delegate = self
        self.unitPicker.dataSource = self
        itemTextView.text = ""
        amountTextView.text = ""
        
        self.pickerText.text = stdPickerOptions[0]
        pickerText.inputView = unitPicker
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let decoded = defaults.object(forKey: "units") as? Data {
            let row = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Int
            currentUnits = row
        }
    }
    
    // Picker info
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(currentUnits == 1) {
            return metricPickerOptions.count
        }
        return stdPickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(currentUnits == 1) {
            return metricPickerOptions[row]
        }
        return stdPickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(currentUnits == 1) {
            pickerText.text = metricPickerOptions[row]
        } else {
            pickerText.text = stdPickerOptions[row]
        }
        self.view.endEditing(true)
    }
    
    func recipeAlert(str:String) {
        let alert = UIAlertController(title: "Add Recipe Error", message: "\(str) field cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Metric to Index Method
    // @param
    // - unit: the numeric representation as passed in from unitsMetric
    // - amount : the value entered in the amount box
    // @description
    // - Used by the add ingredient function to convert the index entry
    //   in unitsMetric to the one used by unitsList and the one which
    //   will be stored in the database
    public func metricToIndex(unit:Int, amount:Double) -> Int {
        if(unit == 1) {
            if(amount < 5.0) {
                return 1
            } else if ( amount < 15.0) {
                return 1
            }
            else if ( amount < 30.0 ) {
                return 2
            } else if ( amount < 240.0 ) {
                return 3
            } else if ( amount < 480.0) {
                return 4
            } else if ( amount < 960.0 ) {
                return 5
            } else {
                return 6
            }
        } else if(unit == 2) {
            if(amount < 30.0) {
                return 7
            } else {
                return 8
            }
        } else if(unit == 3) {
            return 9
        }
        return 0
    }
    
    // Convert Index Method
    // @param
    // - idx : The index in unitsList to convert
    // @description
    // - Takes in an index from unitList and converts it to an index
    //   for unitsMetric
    // - Primarily used to set the units when selecting from autofill
    //   and in the event the user is choosing to display metric units
    public func convertIndex(idx:Int)->Int {
        if(idx < 1) {
            return 0
        } else if(idx < 7) {
            return 1
        } else if(idx < 9) {
            return 2
        } else {
            return 3
        }
    }
    
    // Add ingredient protocol called. Ingredient info must be present
    @IBAction func addIngredient(_ sender: Any) {
        if(itemTextView.text! == "") {
            self.recipeAlert(str: "Item name")
            return
        }
        if(amountTextView.text! == "") {
            self.recipeAlert(str: "Item amount")
            return
        }
        
        var ing = IngredientRecord()
        ing.name = itemTextView.text!
        ing.unit = Int(amountTextView.text!)!
        ing.label = pickerText.text!
        //let item = Ingredient(id: 1, name: itemTextView.text!, unit: Int(amountTextView.text!)!, customLabel: pickerText.text!)
        
        /*
        if whichController == 0 {
            sDelegate?.addSItem(item: item)
        }
        else if whichController == 1 {
            pDelegate?.addPItem(item: item)
        }
        else {
            iDelegate?.addIngredient(ingredient: item)
        }
 */
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    


}
