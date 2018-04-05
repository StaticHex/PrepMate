//
//  AddDirectionPopoverViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class AddDirectionPopoverViewController: UIViewController {

    weak var dDelegate: firstPageProtocol?
    
    @IBOutlet weak var directionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Adding a direction to the first page add recipe controller. User must input some text to add it.
    @IBAction func saveDirection(_ sender: Any) {
        let direction = directionText.text!
        if direction == "" {
            directionText.text = "Direction must not be empty"
            return
        }
        dDelegate?.addDirection(direction: direction)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func discardDirection(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
