//
//  AddVitaminPopoverViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol addVitaminProtocol: class {
    func addVitamin(vitamin:Vitamin)
}

class AddVitaminPopoverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Outlets
    @IBOutlet weak var vitaminTextView: UITextField!
    @IBOutlet weak var percentDailyValue: UITextField!
    
    // Picker Information
    var unitPicker = UIPickerView()
    var pickerOptions: [String] = vitaminList
    
    weak var addVitaminDelegate: addVitaminProtocol?
    
    // Setting up settings for the current display such as picker info and labels
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.unitPicker.delegate = self
        self.unitPicker.dataSource = self
        vitaminTextView.inputView = unitPicker
        
        self.vitaminTextView.text = ""
        self.percentDailyValue.text = ""

        self.vitaminTextView.text = pickerOptions[0]
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
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        vitaminTextView.text = pickerOptions[row]
        self.view.endEditing(true)
    }
    
    // Add a vitamin to the vitamin table in the add recipe second page view controller. Both inputs must be required by the user to add the vitamin
    @IBAction func saveVitamin(_ sender: Any) {
        if vitaminTextView.text! == "" || percentDailyValue.text! == "" {
            self.recipeAlert(str: "Values must not be empty")
            return
        }
        if Float(percentDailyValue.text!) == nil {
            self.recipeAlert(str: "Percent Daily Value")
        }
        var vitamin = Vitamin()
        vitamin.idx = vitaminList.index(of: vitaminTextView.text!)!
        vitamin.percent = Double(percentDailyValue.text!)!
        addVitaminDelegate?.addVitamin(vitamin: vitamin)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func discard(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// Helper function to alert recipe errors
    func recipeAlert(str:String) {
        let alert = UIAlertController(title: "Add Vitamin Error", message: "\(str) field cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
