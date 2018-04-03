//
//  ColorPickerViewController.swift
//  PrepMate
//
//  Created by Joseph Bourque on 4/3/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    // UI Component Outlets
    @IBOutlet weak var txtRed: UITextField!
    @IBOutlet weak var txtGreen: UITextField!
    @IBOutlet weak var txtBlue: UITextField!
    @IBOutlet weak var sldRed: UISlider!
    @IBOutlet weak var sldGreen: UISlider!
    @IBOutlet weak var sldBlue: UISlider!
    @IBOutlet weak var txtHex: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPickClick(_ sender: Any) {
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
    }
    
    @IBAction func onEditRed(_ sender: Any) {
    }
    @IBAction func onEditGreen(_ sender: Any) {
    }
    @IBAction func onEditBlue(_ sender: Any) {
    }
    @IBAction func onRedChanged(_ sender: Any) {
    }
    @IBAction func onGreenChanged(_ sender: Any) {
    }
    @IBAction func onBlueChanged(_ sender: Any) {
    }
    @IBAction func onEditHex(_ sender: Any) {
    }
}
