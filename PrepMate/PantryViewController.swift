//
//  PantryViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/20/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol pantryProtocol : class {
    func addPItem(item: Ingredient)
    func removePItem(cell: PantryItemCustomTableViewCell)
}

var pantryListItems = [Ingredient]()

class PantryViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, pantryProtocol {

    @IBOutlet weak var pantryListTableView: UITableView!
    
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
                vc?.pDelegate = self
                vc?.whichController = 1
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
        cell.itemName.text = pantryListItems[row].getName()
        cell.itemAmount.text = String(pantryListItems[row].getUnit()) + " " + pantryListItems[row].getLabel()
        
        return cell
    }
    
    @IBAction func onAddClick(_ sender: Any) {
        self.performSegue(withIdentifier: "newListItemSegue2", sender: AnyClass.self)
    }
    
    // Add a pantry item for the table view display
    func addPItem(item: Ingredient) {
        pantryListItems.insert(item, at: 0)
        self.pantryListTableView.beginUpdates()
        self.pantryListTableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        self.pantryListTableView.endUpdates()
    }
    
    // Remove a table view cell from the pantry table view
    func removePItem(cell: PantryItemCustomTableViewCell) {
        let indexPath = self.pantryListTableView.indexPath(for: cell)
        pantryListItems.remove(at: indexPath!.row)
        self.pantryListTableView.deleteRows(at: [indexPath!], with: .fade)
    }
}
