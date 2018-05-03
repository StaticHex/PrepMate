//
//  AddIngredientViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 4/4/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//
import UIKit

protocol AddIngredientProtocol : class {
    func addReturnedIngredient(ingredient : RecipeIngredient)
}
class AddIngredientViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var itemTextView: UITextField!
    @IBOutlet weak var amountTextView: UITextField!
    @IBOutlet weak var txtLabel: UITextField!
    @IBOutlet weak var tvAutoComp: UITableView!
    @IBOutlet weak var pckUnits: UIPickerView!
    
    var newIngredient = RecipeIngredient()
    var ingredients = [Ingredient]()
    var finished = false
    var thisRow = 0
    var eMsg = ""
    
    weak var addIngredientDelegate : AddIngredientProtocol?
    
    // Picker information
    var stdPickerOptions = ["custom", "tsp", "tbsp", "fl. oz", "cup", "pint", "quart", "oz", "lb", "in"]
    var metricPickerOptions = ["custom", "ml", "g", "cm"]
    var currentUnits = 0
    
    // Setting up the display on the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvAutoComp.delegate = self
        self.tvAutoComp.dataSource = self
        self.pckUnits.delegate = self
        self.pckUnits.dataSource = self
        itemTextView.addTarget(self, action: #selector(nameDidChange(_:)), for: .editingChanged)
        itemTextView.text = ""
        amountTextView.text = ""
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
        tvAutoComp.isHidden = true;
        ingredients.removeAll()
        finished = false
        pckUnits.selectRow(0, inComponent: 0, animated: false)
        thisRow = 0
        txtLabel.isEnabled = true
        newIngredient = RecipeIngredient()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tvAutoComp.isHidden = true
        textField.resignFirstResponder()
        return false
    }
    
    // Update display when typing in a name of an ingrdient
    @objc func nameDidChange(_ textField :UITextField) {
        ingredients.removeAll()
        if(textField.text! != "") {
            if(!ingredientAutofill(str: textField.text!)) {
                tvAutoComp.reloadData()
            } else {
                print(self.eMsg)
            }
        } else {
            self.ingredients.removeAll()
            tvAutoComp.reloadData()
            tvAutoComp.isHidden = true
        }
        if(ingredients.count > 0) {
            tvAutoComp.isHidden = false
            tvAutoComp.reloadData()
        } else {
            tvAutoComp.isHidden = true
        }
    }
    
    // Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutofillCell", for: indexPath as IndexPath)
        
        let row = indexPath.row
        let unit = self.ingredients[row].getUnit()
        cell.textLabel?.text = self.ingredients[row].getName()
        if(unit == 0) {
            cell.detailTextLabel?.text = self.ingredients[row].getLabel()
        } else {
            cell.detailTextLabel?.text = unitList[unit].std
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        itemTextView.text = ingredients[row].getName()
        itemTextView.isEnabled = false

        // find out whether we're in standard or metric
        var currentUnits = 0
        let defaults = UserDefaults.standard
        if let decoded = defaults.object(forKey: "units") as? Data {
            let r = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Int
            currentUnits = r
        }
        // adjust units if in metric
        if currentUnits == 0 {
            pckUnits.selectRow(ingredients[row].getUnit(), inComponent: 0, animated: false)
        } else {
            let adjusted = convertIndex(idx: ingredients[row].getUnit())
            pckUnits.selectRow(adjusted, inComponent: 0, animated: false)
        }
        thisRow = ingredients[row].getUnit()
        pckUnits.isUserInteractionEnabled = false
        txtLabel.text = ingredients[row].getLabel()
        txtLabel.isEnabled = false
        newIngredient.item = ingredients[row]
        tvAutoComp.isHidden = true
        ingredients.removeAll()
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
        thisRow = row
        if(row==0) {
            txtLabel.isEnabled = true
        } else {
            txtLabel.isEnabled = false
            txtLabel.text = ""
        }
        self.view.endEditing(true)
    }
    
    // Alert for if the field is empty
    func recipeAlert(str:String) {
        let alert = UIAlertController(title: "Add Recipe Error", message: "\(str) field cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Autofill
    func ingredientAutofill(str:String) -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AutofillIngredient.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "str=\(str)"
        
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                self.eMsg = error!.localizedDescription
                finished = true
                vError = true
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    self.eMsg = parseJSON["msg"] as! String
                    vError = (parseJSON["error"] as! Bool)
                    if(!vError) {
                        var count = 0
                        while let record = parseJSON[String(count)] as? NSString {
                            if let entry = try JSONSerialization.jsonObject(with: record.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                                if let strId = entry["id"] as? String {
                                    let newIng = Ingredient()
                                    DispatchQueue.main.async {
                                        vError = newIng.getIngredient(iid: Int(strId)!)
                                    }
                                    if(vError) {
                                        break
                                    }
                                    self.ingredients.append(newIng)
                                } else {
                                    vError = true
                                    break
                                }
                            }
                            count+=1
                        }
                    }
                }
            } catch {
                self.eMsg = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        return vError
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
        
        // Check to see if user input standard units and if so, convert amount to metric
        // (remember, all database entries are metric)
        var amount = Double(amountTextView.text!)!

        if(currentUnits==0) {
            amount = stdToMetric(unit: thisRow, amount: amount)
        }
        
        if(newIngredient.item.getId() < 0) {
            var ing = IngredientRecord()
            ing.name = itemTextView.text!
            ing.unit = thisRow
            ing.label = txtLabel.text!
            if(!newIngredient.item.addIngredient(newIngredient: ing)) {
                newIngredient.amount = amount
            }
        } else {
            newIngredient.amount = amount
        }
        print(newIngredient)
        addIngredientDelegate?.addReturnedIngredient(ingredient: newIngredient)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
