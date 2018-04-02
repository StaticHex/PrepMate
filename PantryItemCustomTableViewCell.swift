//
//  PantryItemCustomTableViewCell.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/26/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class PantryItemCustomTableViewCell: UITableViewCell {

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
    

    @IBAction func selectItem(_ sender: Any) {
        if selectedItem.currentTitle == "□" {
            selectedItem.setTitle("■", for: .normal)
        }
        else if selectedItem.currentTitle == "■" {
            selectedItem.setTitle("□", for: .normal)
        }
    }

    @IBAction func removePantryItem(_ sender: Any) {
        pDelegate?.removePItem(cell: self)
    }
    
}
