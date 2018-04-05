//
//  AddVitaminPopoverViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class AddVitaminPopoverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var vitaminTextView: UITextField!
    @IBOutlet weak var percentDailyValue: UITextField!
    @IBOutlet weak var inputError: UILabel!
    
    var unitPicker = UIPickerView()
    var pickerOptions: [String] = vitaminList
    
    weak var secondDelegate: secondPageProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.unitPicker.delegate = self
        self.unitPicker.dataSource = self
        vitaminTextView.inputView = unitPicker
        
        inputError.text = ""
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
    
    // Add a vitamin to the vitamin table in the add recipe second page view controller
    @IBAction func saveVitamin(_ sender: Any) {
        if vitaminTextView.text! == "" || percentDailyValue.text! == "" {
            inputError.text = "Values must be non-empty"
            return
        }
        if Float(percentDailyValue.text!) == nil {
            inputError.text = "Percentage must be a number"
        }
        let vitamin = Vitamin(id: -1, index: vitaminList.index(of: vitaminTextView.text!)!, percent: Float(percentDailyValue.text!)!)
        secondDelegate?.addVitamin(vitamin: vitamin)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func discard(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
