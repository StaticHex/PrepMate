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
    @IBOutlet weak var btnColor: UIButton!
    
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onEditRed(_ sender: Any) {
        if(txtRed.text! == "") {
            txtRed.text = "0"
        }
        let rCol = Float(txtRed.text!)!
        let gCol = Float(txtGreen.text!)!
        let bCol = Float(txtBlue.text!)!
        sldRed.setValue(rCol, animated: false)
        btnColor.backgroundColor = UIColor(red: CGFloat(rCol / 255.0),
                                           green: CGFloat(gCol / 255.0),
                                           blue: CGFloat(bCol / 255.0), alpha: 1.0)
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
