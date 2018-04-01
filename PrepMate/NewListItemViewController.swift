//
//  NewListItemViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/20/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class NewListItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var itemNameInput: UITextField!
    @IBOutlet weak var amountInput: UITextField!
    
    @IBOutlet weak var pickerText: UITextField!
    
    weak var pDelegate : addShoppingListItem?

    var unitPicker = UIPickerView()
    var pickerOptions: [String] = ["Cups", "Quarts", "Lbs", "Custom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.unitPicker.delegate = self
        self.unitPicker.dataSource = self
        itemNameInput.text = ""
        amountInput.text = ""
        self.pickerText.text = pickerOptions[0]
        pickerText.inputView = unitPicker
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // Picker info
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    // Got off tutorial
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerText.text = pickerOptions[row]
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func selectUnits(_ sender: Any) {
        // if value of don't show is true, go straight to units
        // else don't show
        // Protocol method here
        self.performSegue(withIdentifier: "customUnitWarningSegue", sender: AnyClass.self)
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        // TODO: Save item

        // Need to check if coming from shopping list or pantry list
        print(itemNameInput.text!)
        print(amountInput.text!)
        let item = Ingredient(id: 1, name: itemNameInput.text!, unit: Int(amountInput.text!)!, customLabel: "empty")
        pDelegate?.addItem(item: item)
        dismiss(animated: true, completion: nil)
    }
    
    
}
