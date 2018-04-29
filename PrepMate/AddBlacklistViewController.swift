//
//  AddBlacklistViewController.swift
//  PrepMate
//
//  Created by Joseph Bourque on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol bListProtocol : class {
    func updateBlist(item: (bl_key: String, bl_value: Int))
}

class AddBlacklistViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // data for our first picker
    let pckrItemTypeData = ["Category", "Ingredient", "Type"]
    
    // delegate to pass our data back to the caller
    weak var bListDelegate : bListProtocol?
    
    // UI Component Outlets
    @IBOutlet weak var pckrItemType: UIPickerView!
    @IBOutlet weak var pckrItemName: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pckrItemType.delegate = self
        self.pckrItemType.dataSource = self
        self.pckrItemName.delegate = self
        self.pckrItemType.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pckrItemType {
            return pckrItemTypeData.count
        }
        if pickerView == pckrItemName {
            switch(pckrItemTypeData[pckrItemType.selectedRow(inComponent: 0)]) {
            case "Category":
                return categoryList.count
            case "Ingredient":
                return ingredientList.count
            case "Type":
                return foodTypeList.count
            default:
                break
            }
        }
        return -1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pckrItemType {
            return pckrItemTypeData[row]
        }
        if pickerView == pckrItemName {
            if pickerView == pckrItemName {
                switch(pckrItemTypeData[pckrItemType.selectedRow(inComponent: 0)]) {
                case "Category":
                    return categoryList[row]
                case "Ingredient":
                    return ingredientList[row].name
                case "Type":
                    return foodTypeList[row].name
                default:
                    break
                }
            }
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pckrItemType {
            pckrItemName.reloadAllComponents()
        }
    }
    
    @IBAction func onAddClick(_ sender: Any) {
        var bListItem = (bl_key: "", bl_value: 0)
        bListItem.bl_key = pckrItemTypeData[pckrItemType.selectedRow(inComponent: 0)]
        bListItem.bl_value = pckrItemName.selectedRow(inComponent: 0)
        bListDelegate?.updateBlist(item: bListItem)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
