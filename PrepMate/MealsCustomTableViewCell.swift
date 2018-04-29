//
//  MealsCustomTableViewCell.swift
//  PrepMate
//
//  Created by Pablo Velasco on 4/1/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class MealsCustomTableViewCell: UITableViewCell {

    // Outlets
    
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var selectedItem: UIButton!
    @IBOutlet weak var removeItem: UIButton!
    
    
    weak var mProtocol: mealsProtocol?
    
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
        var title = "■"
        if selectedItem.currentTitle == "■" {
            title = "□"
        }
        else {
            title = "■"
        }
        UIView.performWithoutAnimation {
            self.selectedItem.setTitle(title, for: .normal)
            self.selectedItem.layoutIfNeeded()
        }
        
    }

    // Protocol called to remove cell from table view
    @IBAction func remove(_ sender: Any) {
        mProtocol?.removeMeal(cell: self)
    }
    
    
    
    
    
}
