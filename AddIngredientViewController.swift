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
    
    @IBOutlet weak var pickerText: UITextField!
    
    weak var iDelegate : firstPageProtocol?
    
    // Picker information
    var unitPicker = UIPickerView()
    var amountPickerOptions: [String] = ["Cups", "Quarts", "Lbs"]
    
    // Setting up the display on the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        self.unitPicker.delegate = self
        self.unitPicker.dataSource = self
        itemTextView.text = ""
        amountTextView.text = ""
        self.pickerText.text = amountPickerOptions[0]
        pickerText.inputView = unitPicker
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Picker info
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return amountPickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return amountPickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerText.text = amountPickerOptions[row]
        self.view.endEditing(true)
    }
    
    func recipeAlert(str:String) {
        let alert = UIAlertController(title: "Add Recipe Error", message: "\(str) field cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
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
        
        let item = Ingredient(id: 1, name: itemTextView.text!, unit: Int(amountTextView.text!)!, customLabel: pickerText.text!)
        iDelegate?.addIngredient(ingredient: item)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    


}
