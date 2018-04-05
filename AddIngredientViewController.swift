//
//  AddIngredientViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 4/4/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class AddIngredientViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var itemTextView: UITextField!
    @IBOutlet weak var amountTextView: UITextField!
    @IBOutlet weak var amountPickerTextView: UITextField!
    @IBOutlet weak var inputError: UILabel!
    
    @IBOutlet weak var pickerText: UITextField!
    
    weak var iDelegate : firstPageProtocol?
    
    var unitPicker = UIPickerView()
    var amountPickerOptions: [String] = ["Cups", "Quarts", "Lbs", "Custom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.unitPicker.delegate = self
        self.unitPicker.dataSource = self
        itemTextView.text = ""
        amountTextView.text = ""
        inputError.text = ""
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
    
    // Got off tutorial
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return amountPickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerText.text = amountPickerOptions[row]
        self.view.endEditing(true)
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        if amountTextView.text! == "" || itemTextView.text! == ""
        {
            inputError.text = "Fields cannot be empty"
            return
        }
        
        if Int(amountTextView.text!) == nil {
            amountTextView.text! = ""
            inputError.text = "Amount must be a number"
            return
        }
        
        let item = Ingredient(id: 1, name: itemTextView.text!, unit: Int(amountTextView.text!)!, customLabel: "empty")
        iDelegate?.addIngredient(ingredient: item)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    


}
