//
//  AddRecipeFirstPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class DirectionTableCell: UITableViewCell {
    @IBOutlet weak var directionLabel: UILabel!
}

class IngredientTableCell: UITableViewCell {
    @IBOutlet weak var ingLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
}
class AddRecipeFirstPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recipeNameField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var servingsPicker: UIPickerView!
    @IBOutlet weak var prepTimeField: UITextField!
    @IBOutlet weak var cookTimeField: UITextField!
    @IBOutlet weak var directionTableview: UITableView!
    @IBOutlet weak var ingTableView: UITableView!
    var directionList = [String]()
    var ingList = [Ingredient]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.directionTableview {
            return directionList.count
        }
        if tableView == self.ingTableView {
            return ingList.count
        }
        return -1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.directionTableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "directionTableCell", for: indexPath as IndexPath) as! DirectionTableCell
            return cell
        }
        if tableView == self.ingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientTableCell", for: indexPath as IndexPath) as! IngredientTableCell
            return cell
            
        }
        return UITableViewCell()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
}
