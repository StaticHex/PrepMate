//
//  BlacklistCell.swift
//  PrepMate
//
//  Created by Joseph Bourque on 3/17/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol bListCellProtocol : class {
    func removeBListCell(idx : Int)
}
class BlacklistCell: UITableViewCell {
    var idx : Int?
    weak var bListDelegate : bListCellProtocol?
    //UI Component Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRemoveClick(_ sender: Any) {
        bListDelegate?.removeBListCell(idx: idx!)
    }
}
