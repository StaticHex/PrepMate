//
//  ColorPickerViewController.swift
//  PrepMate
//
//  Created by Joseph Bourque on 4/3/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol ColorPickProtocol : class {
    func updateColor(color : UIColor?, sender : Int)
}

class ColorPickerViewController: UIViewController {
    // UI Component Outlets
    // whichBox - 1 is font color, 0 is background color
    var whichBox : Int = 0
    weak var colorDelegate : ColorPickProtocol?
    
    @IBOutlet weak var txtRed: UITextField!
    @IBOutlet weak var txtGreen: UITextField!
    @IBOutlet weak var txtBlue: UITextField!
    @IBOutlet weak var sldRed: UISlider!
    @IBOutlet weak var sldGreen: UISlider!
    @IBOutlet weak var sldBlue: UISlider!
    @IBOutlet weak var txtHex: UITextField!
    @IBOutlet weak var btnColor: UIButton! // our color box
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        txtRed.text = "0"
        txtGreen.text = "0"
        txtBlue.text = "0"
        txtHex.text = "#000000"
    }
        
    // Clear contents of text field when user clicks inside
    @IBAction func onBeginEditRed(_ sender: Any) {
        txtRed.text = ""
    }
    
    @IBAction func onBeginEditGreen(_ sender: Any) {
        txtGreen.text = ""
    }
    
    @IBAction func onBeginEditBlue(_ sender: Any) {
        txtBlue.text = ""
    }
    
    @IBAction func onHexEditBegin(_ sender: Any) {
        txtHex.text = ""
    }
    
    // keyboard clear functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onPickClick(_ sender: Any) {
        colorDelegate?.updateColor(color: btnColor.backgroundColor, sender: whichBox)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // When anything is changed, update everything else
    // - when the hex number is updated, update sliders and R/G/B boxes
    // - when R/G/B boxes are updated, update sliders and hex number
    // - when sliders are updated, update corresponding R/G/B box
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
        txtHex.text = "#" + rgbToHex(red: Int(rCol), green: Int(gCol), blue: Int(bCol))
    }
    @IBAction func onEditGreen(_ sender: Any) {
        if(txtGreen.text! == "") {
            txtGreen.text = "0"
        }
        let rCol = Float(txtRed.text!)!
        let gCol = Float(txtGreen.text!)!
        let bCol = Float(txtBlue.text!)!
        sldGreen.setValue(rCol, animated: false)
        btnColor.backgroundColor = UIColor(red: CGFloat(rCol / 255.0),
                                           green: CGFloat(gCol / 255.0),
                                           blue: CGFloat(bCol / 255.0), alpha: 1.0)
        txtHex.text = "#" + rgbToHex(red: Int(rCol), green: Int(gCol), blue: Int(bCol))
    }
    @IBAction func onEditBlue(_ sender: Any) {
        if(txtBlue.text! == "") {
            txtBlue.text = "0"
        }
        let rCol = Float(txtRed.text!)!
        let gCol = Float(txtGreen.text!)!
        let bCol = Float(txtBlue.text!)!
        sldBlue.setValue(rCol, animated: false)
        btnColor.backgroundColor = UIColor(red: CGFloat(rCol / 255.0),
                                           green: CGFloat(gCol / 255.0),
                                           blue: CGFloat(bCol / 255.0), alpha: 1.0)
        txtHex.text = "#" + rgbToHex(red: Int(rCol), green: Int(gCol), blue: Int(bCol))
    }
    @IBAction func onRedChanged(_ sender: Any) {
        txtRed.text = String(Int(sldRed.value))
        let rCol = Float(txtRed.text!)!
        let gCol = Float(txtGreen.text!)!
        let bCol = Float(txtBlue.text!)!
        btnColor.backgroundColor = UIColor(red: CGFloat(rCol / 255.0),
                                           green: CGFloat(gCol / 255.0),
                                           blue: CGFloat(bCol / 255.0), alpha: 1.0)
        txtHex.text = "#" + rgbToHex(red: Int(rCol), green: Int(gCol), blue: Int(bCol))
        
    }
    @IBAction func onGreenChanged(_ sender: Any) {
        txtGreen.text = String(Int(sldGreen.value))
        let rCol = Float(txtRed.text!)!
        let gCol = Float(txtGreen.text!)!
        let bCol = Float(txtBlue.text!)!
        btnColor.backgroundColor = UIColor(red: CGFloat(rCol / 255.0),
                                           green: CGFloat(gCol / 255.0),
                                           blue: CGFloat(bCol / 255.0), alpha: 1.0)
        txtHex.text = "#" + rgbToHex(red: Int(rCol), green: Int(gCol), blue: Int(bCol))
    }
    @IBAction func onBlueChanged(_ sender: Any) {
        txtBlue.text = String(Int(sldBlue.value))
        let rCol = Float(txtRed.text!)!
        let gCol = Float(txtGreen.text!)!
        let bCol = Float(txtBlue.text!)!
        btnColor.backgroundColor = UIColor(red: CGFloat(rCol / 255.0),
                                           green: CGFloat(gCol / 255.0),
                                           blue: CGFloat(bCol / 255.0), alpha: 1.0)
        txtHex.text = "#" + rgbToHex(red: Int(rCol), green: Int(gCol), blue: Int(bCol))
    }
    @IBAction func onEditHex(_ sender: Any) {
        var hexStr : String = ""
        if(txtHex.text!.count == 7) {
            hexStr = substring(tok: txtHex.text!, begin: 1, end: txtHex.text!.count)
        } else if (txtHex.text!.count == 6){
            hexStr = txtHex.text!
        }
        let colors = hexTorgb(hex: hexStr)
        let rCol = Float(colors.red)
        let gCol = Float(colors.green)
        let bCol = Float(colors.blue)
        txtRed.text = String(colors.red)
        txtGreen.text = String(colors.green)
        txtBlue.text = String(colors.blue)
        sldRed.value = rCol
        sldGreen.value = gCol
        sldBlue.value = bCol

        btnColor.backgroundColor = UIColor(red: CGFloat(rCol / 255.0),
                                           green: CGFloat(gCol / 255.0),
                                           blue: CGFloat(bCol / 255.0), alpha: 1.0)
    }
    
    // rgbToHex Function
    // @param
    // - red : red color component
    // - green : green color component
    // - blue : blue color component
    // @description
    // - Calls a recursive helper function on each component, formats
    //   the components so that the hex string is always 6 digits long,
    //   and then returns the formatted hex string
    func rgbToHex(red : Int, green : Int, blue : Int) -> String {
        var sRed = dtoh(decimal: red)
        var sGreen = dtoh(decimal: green)
        var sBlue = dtoh(decimal: blue)
        if sRed.count < 2 {
            sRed = "0" + sRed
        }
        if sGreen.count < 2 {
            sGreen = "0" + sGreen
        }
        if sBlue.count < 2 {
            sBlue = "0" + sBlue
        }
        return sRed + sGreen + sBlue
    }
    
    // dtoh (decimal to hex) function
    // @param
    // - decimal : the base 10 number to convert to hex
    // @description
    // - recursive helper function for the rgbToHex function,
    //   converts a single decimal number to a hex value
    private func dtoh(decimal : Int) -> String {
        var digits = ["0","1","2","3","4","5","6","7",
                    "8","9","A","B","C","D","E","F"]
        if(decimal < 16) {
            return digits[decimal]
        }
        return dtoh(decimal: decimal / 16) + digits[decimal % 16]
    }
    
    // hexToRgb Function
    // @param
    // - hex : the hex string to convert to component values
    // @description
    // - Splits the hex string into sub strings and then calls a recursive helper function
    //   to convert each substring into it's corresponding base 10 decimal value.
    // @return
    // - returns a tuple containing 3 values representing R/G/B component values
    func hexTorgb(hex : String) -> (red : Int, green : Int, blue : Int) {
        let sRed = substring(tok: hex, begin: 0, end: 2)
        let sGreen = substring(tok: hex, begin: 2, end: 4)
        let sBlue = substring(tok: hex, begin: 4, end: 6)
        return (red : hexHelper(tok: sRed, p: 1), green : hexHelper(tok: sGreen, p: 1),blue : hexHelper(tok: sBlue, p: 1))
    }
    
    // hexHelper
    // @param
    // - tok : the string token to convert
    // - p : the power to multiply the character by
    // @description
    // - Recursively converts a hex value to it's base 10 counterpart
    private func hexHelper(tok : String, p : Int) -> Int{
        var digits = ["0","1","2","3","4","5","6","7",
                      "8","9","A","B","C","D","E","F"]
        if (p == 0) {
            for i in 0...(digits.count-1) {
                if tok == digits[i] {
                    return i
                }
            }
        }
        var delim : Int = 0
        let sub = substring(tok : tok, begin : 0, end : 1)
        let remain = substring(tok : tok, begin : 1, end : tok.count)

        for i in 0...(digits.count-1) {
            if digits[i] == sub {
                delim = i
            }
        }

        return Int(Float(delim)*pow(16, Float(p)) + Float(hexHelper(tok: remain, p: p - 1)))
    }
}
