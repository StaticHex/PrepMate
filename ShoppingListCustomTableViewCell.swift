//
//  ShoppingListCustomTableViewCell.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/26/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class ShoppingListCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedItem: UIButton!
    @IBOutlet weak var itemAmount: UILabel!
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteItem(_ sender: Any) {
        // Delete
        // Protocol function here
    }
    
    @IBAction func selectItem(_ sender: Any) {
        selectedItem.setTitle("■", for: .normal)
        // Save
        // Protocol function here
    }
}
