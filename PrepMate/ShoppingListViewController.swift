//
//  ShoppingListViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/20/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol shoppingListProtocol: class {
    func addSItem(item: pantrySLItem)
    func removeShoppingItem(cell: ShoppingListCustomTableViewCell)

}

struct pantrySLItem {
    var id : Int?
    var ingredientId : Int?
    var amount: Double?
    var ingredientName : String?
    var ingredientUnit : Int?
    var ingredientLabel : String?
    var managed : Int?
}

class ShoppingListViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, shoppingListProtocol, AddIngredientProtocol {

    @IBOutlet weak var shoppingListTableView: UITableView!
    
    var eMsg = "" // holds error message returned by recipe list functions

    var shoppingListRecords = [pantrySLItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
    navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // CALL DB TO POPULATE
        //        shoppingListRecords =
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newListItemSegue" {
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

    @IBAction func addNewItem(_ sender: Any) {
        self.performSegue(withIdentifier: "newListItemSegue", sender: AnyClass.self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingListRecords.count
    }
    
    
    // Display information about the shopping list item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:ShoppingListCustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "shoppingListTableCell", for: indexPath as IndexPath) as! ShoppingListCustomTableViewCell
        
        cell.sProtocol = self
        
        let row = indexPath.row

        let defaults = UserDefaults.standard
        let idx = shoppingListRecords[row].ingredientUnit!
        if defaults.integer(forKey: "units") == 0 {
            let valToDisplay = metricToStd(unit: shoppingListRecords[row].ingredientUnit!, amount: shoppingListRecords[row].amount!)
            cell.itemAmount.text = String(valToDisplay) + " " + unitList[idx].std
        }
        else {
            cell.itemAmount.text = String(shoppingListRecords[row].amount!) + " " + unitList[idx].metric
        }
        
        cell.itemName.text = shoppingListRecords[row].ingredientName!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func addReturnedIngredient(ingredient: RecipeIngredient) {
        let defaults = UserDefaults.standard
        var managed = 0
        if defaults.integer(forKey: "amSList") == 1 {
            managed = 1
        }
        let itemToAdd = pantrySLItem(id: currentUser.getId(), ingredientId: ingredient.id, amount: ingredient.amount, ingredientName: ingredient.item.getName(), ingredientUnit: ingredient.item.getUnit(), ingredientLabel: ingredient.item.getLabel(), managed: managed)
        addSItem(item: itemToAdd)
    }
    
    // Add an item to the shopping list table view. Non-db yet
    func addSItem(item: pantrySLItem) {
        
        // DO DATABASE CALL HERE
        addShoppingListITem(newItem: item)
        shoppingListRecords.append(item)
        self.shoppingListTableView.beginUpdates()
        self.shoppingListTableView.insertRows(at: [IndexPath.init(row: shoppingListRecords.count-1, section: 0)], with: .automatic)
        self.shoppingListTableView.endUpdates()
    }
    
    // Remove an item from the shopping list table view
    func removeShoppingItem(cell: ShoppingListCustomTableViewCell) {
        let indexPath = self.shoppingListTableView.indexPath(for: cell)
        shoppingListRecords.remove(at: indexPath!.row)
        self.shoppingListTableView.deleteRows(at: [indexPath!], with: .fade)
    }
    
    // Functions for dealing with user recipes (should be keeping a list of these for recipe box and favorites)
    func addShoppingListITem(newItem :pantrySLItem) -> Bool {
        // create mutable object out of parameter
        var sLItem = newItem
        
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddUserRecipe.php"
        
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
                        if let sId = parseJSON["id"] as? String {
                            sLItem.id = Int(sId)!
                            if let ingredientId = parseJSON["iid"] as? String {
                                sLItem.ingredientId = Int(ingredientId)!
                                if let amount = parseJSON["amount"] as? Double {
                                    sLItem.amount = amount
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
            self.shoppingListRecords.append(sLItem)
        }
        return vError
    }
    
    
}
