//
//  MealsCustomTableViewCell.swift
//  PrepMate
//
//  Created by Pablo Velasco on 4/1/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class MealsCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var rating: UIImageView!
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
    
    
    @IBAction func selectItem(_ sender: Any) {
        if selectedItem.currentTitle == "★" {
            selectedItem.setTitle("☆", for: .normal)
        }
        else {
            selectedItem.setTitle("★", for: .normal)
        }

    }
    
    @IBAction func remove(_ sender: Any) {
        print("Huey")
        mProtocol?.removeMeal(cell: self)
    }
    
    
    
    
    
}
