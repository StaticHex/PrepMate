//
//  PantryViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/20/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol pantryProtocol : class {
    func addPItem(item: pantrySLItem)
    func removePItem(cell: PantryItemCustomTableViewCell)
}


class PantryViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, pantryProtocol, AddIngredientProtocol {

    @IBOutlet weak var pantryListTableView: UITableView!
    
    var pantryListItems = [pantrySLItem]()

    var eMsg = "" // holds error message returned by recipe list functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pantryListTableView.delegate = self
        pantryListTableView.dataSource = self
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPantryListItems(uid: currentUser.getId())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newListItemSegue2" {
            let vc = segue.destination as? AddIngredientViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.addIngredientDelegate = self
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pantryListItems.count
    }
    
    // Display information about the pantry item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PantryItemCustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "pantryListTableCell", for: indexPath as IndexPath) as! PantryItemCustomTableViewCell
        
        cell.pDelegate = self
        
        let row = indexPath.row
        
        let defaults = UserDefaults.standard

        let idx = pantryListItems[row].ingredientUnit!
        // Standard
        if defaults.integer(forKey: "units") == 0 {
           let valToDisplay = metricToStd(unit: pantryListItems[row].ingredientUnit!, amount: pantryListItems[row].amount!)
            if pantryListItems[row].ingredientLabel != "" {
                cell.itemAmount.text = String(valToDisplay) + " " + pantryListItems[row].ingredientLabel!
            }
            else {
                cell.itemAmount.text = String(valToDisplay) + " " + unitList[idx].std
            }
        }
        else {
            cell.itemAmount.text = String(pantryListItems[row].amount!) + " " + unitList[idx].metric
        }
        cell.itemName.text = pantryListItems[row].ingredientName!
        
        return cell
    }
    
    @IBAction func onAddClick(_ sender: Any) {
        self.performSegue(withIdentifier: "newListItemSegue2", sender: AnyClass.self)
    }
    
    func addReturnedIngredient(ingredient: RecipeIngredient) {
        let defaults = UserDefaults.standard
        var managed = 0
        if defaults.integer(forKey: "amSList") == 1 {
            managed = 1
        }
        let itemToAdd = pantrySLItem(id: currentUser.getId(), ingredientId: ingredient.item.getId(), amount: ingredient.amount, ingredientName: ingredient.item.getName(), ingredientUnit: ingredient.item.getUnit(), ingredientLabel: ingredient.item.getLabel(), managed: managed)
        addPItem(item: itemToAdd)
    }
    // Add a pantry item for the table view display
    func addPItem(item: pantrySLItem) {
        if(!addPantryListItem(newItem: item)) {
            self.pantryListTableView.reloadData()
        }
    }
    
    // Remove a table view cell from the pantry table view
    func removePItem(cell: PantryItemCustomTableViewCell) {
        let indexPath = self.pantryListTableView.indexPath(for: cell)
        pantryListItems.remove(at: indexPath!.row)
        self.pantryListTableView.deleteRows(at: [indexPath!], with: .fade)
    }
    
    func addPantryListItem(newItem :pantrySLItem) -> Bool {
        // create mutable object out of parameter
        var sLItem = newItem
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddPantryItem.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // Set up parameters
        
        // Create HTTP Body
        let params = "uid=\(currentUser.getId())&iid=\(newItem.ingredientId!)&amount=\(newItem.amount!)&auto=\(newItem.managed!)"
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
                        print(parseJSON.descriptionInStringsFileFormat)
                        if let sId = parseJSON["code"] as? Int? {
                            print("PARSED ID")
                            sLItem.id = sId!
                            if let ingredientId = parseJSON["iid"] as? Int? {
                                print("PARSED INGREDIENT")
                                sLItem.ingredientId = ingredientId!
                                if let amount = parseJSON["amount"] as? Double? {
                                    print("PARSED AMOUNT")
                                    sLItem.amount = amount!
                                } else {
                                    sLItem.ingredientName = "ERROR"
                                    vError = true
                                    self.eMsg = "error occured while parsing shopping liste from add operation"
                                }
                            }
                        } else {
                            sLItem.id = -1
                            vError = true
                            self.eMsg = "error occured while parsing user shopping list ID from add operation"
                            return
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
        if(!vError) {
            self.pantryListItems.append(sLItem)
        }
        return vError
    }
    
    func getPantryListItems(uid:Int) -> Bool {
        // reset the list
        self.pantryListItems.removeAll()
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/GetPantryItems.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "uid=\(uid)"
        
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
                    vError = (parseJSON["error"] as! Bool)
                    self.eMsg = parseJSON["msg"] as! String
                    if(!vError) {
                        var count = 0
                        while let record = parseJSON["\(count)"] as? String {
                            if let row = try JSONSerialization.jsonObject(with: record.data(using: String.Encoding.utf8)!, options: .mutableContainers) as? NSDictionary {
                                var current = pantrySLItem()
                                if let urId = row["id"] as? String {
                                    current.id = Int(urId)!
                                    if let urRid = row["ingredient_id"] as? String {
                                        current.ingredientId = Int(urRid)!
                                        if let name = row["ingredient_name"] as? String {
                                            current.ingredientName = name
                                            if let unit = row["ingredient_unit"] as? String {
                                                current.ingredientUnit = Int(unit)!
                                                if let label = row["ingredient_label"] as? String {
                                                    current.ingredientLabel = label
                                                    if let amount = row["amount"] as? String {
                                                        current.amount = Double(amount)!
                                                        self.pantryListItems.append(current)
                                                    }
                                                    else {
                                                        vError = true
                                                        self.eMsg = "Error occured while parsing out ingredient amount in shoppping list items"
                                                    }
                                                } else {
                                                    vError = true
                                                    self.eMsg = "Error occured while parsing user shopping list in get shopping list items"
                                                    return
                                                }
                                            } else {
                                                vError = true
                                                self.eMsg = "Error occured while parsing shopping list in get shopping list items"
                                                return
                                            }
                                        } else {
                                            vError = true
                                            self.eMsg = "Error occured while parsing ingredient name in get sohpping list items"
                                            return
                                        }
                                    } else {
                                        vError = true
                                        self.eMsg = "Error occured while parsing ingreidnet id in get shopping list items"
                                        return
                                    }
                                } else {
                                    vError = true
                                    self.eMsg = "Error occured while parsing user ingreident id in get shopping list items"
                                    return
                                }
                            }
                            count += 1
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
}
