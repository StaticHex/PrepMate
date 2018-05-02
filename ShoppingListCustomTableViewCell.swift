//
//  ShoppingListCustomTableViewCell.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/26/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class ShoppingListCustomTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var selectedItem: UIButton!
    @IBOutlet weak var itemAmount: UILabel!
    @IBOutlet weak var itemName: UILabel!
    
    weak var sProtocol: shoppingListProtocol?
    
    var row : Int?
    var amt : Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Call protocol to remove a cell from the display
    @IBAction func deleteItem(_ sender: Any) {
        sProtocol?.removeShoppingItem(cell: self)
    }
    
    // Select the button on a certain cell
    @IBAction func selectItem(_ sender: Any) {
        var checked = 0
        if selectedItem.currentTitle == "■" {
            selectedItem.setTitle("□", for: .normal)
        }
        else {
            selectedItem.setTitle("■", for: .normal)
            checked = 1
        }
        if let idx = row {
            if let amount = amt {
                if self.sProtocol != nil {
                    if sProtocol!.updateShoppingListItem(idx: idx, amount: amount, checked: checked) {
                        if selectedItem.currentTitle == "■" {
                            selectedItem.setTitle("□", for: .normal)
                        }
                        else {
                            selectedItem.setTitle("■", for: .normal)
                        }
                    }
                }
            }
        }
    }
}
