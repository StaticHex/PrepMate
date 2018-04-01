//
//  ShoppingListViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/20/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

var shoppingListItems = [Ingredient]()

protocol addShoppingListItem: class {
    func addSItem(item: Ingredient)
}

class ShoppingListViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, addShoppingListItem {

    @IBOutlet weak var shoppingListTableView: UITableView!
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newListItemSegue" {
            let vc = segue.destination as? NewListItemViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.sDelegate = self
                vc?.whichController = true
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
        return shoppingListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:ShoppingListCustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "shoppingListTableCell", for: indexPath as IndexPath) as! ShoppingListCustomTableViewCell
        
        let row = indexPath.row
        cell.itemName.text = shoppingListItems[row].getName()
        cell.itemAmount.text = String(shoppingListItems[row].getUnit())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func addSItem(item: Ingredient) {
        shoppingListItems.insert(item, at: 0)
        self.shoppingListTableView.beginUpdates()
        self.shoppingListTableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        self.shoppingListTableView.endUpdates()
    }
}
