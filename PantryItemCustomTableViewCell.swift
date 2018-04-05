//
//  PantryItemCustomTableViewCell.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/26/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class PantryItemCustomTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemAmount: UILabel!
    @IBOutlet weak var selectedItem: UIButton!
    
    weak var pDelegate : pantryProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Select the button on a certain cell
    @IBAction func selectItem(_ sender: Any) {
        if selectedItem.currentTitle == "□" {
            selectedItem.setTitle("■", for: .normal)
        }
        else if selectedItem.currentTitle == "■" {
            selectedItem.setTitle("□", for: .normal)
        }
    }

    // Protocol called to remove item from table view
    @IBAction func removePantryItem(_ sender: Any) {
        pDelegate?.removePItem(cell: self)
    }
    
}
