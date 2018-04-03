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
    var whichBox : Int = 0
    weak var colorDelegate : ColorPickProtocol?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        txtRed.text = "0"
        txtGreen.text = "0"
        txtBlue.text = "0"
        txtHex.text = "#000000"
    }
        
    // Called when the user touches on the main view (outside the UITextField).
    //
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
    
    private func dtoh(decimal : Int) -> String {
        var digits = ["0","1","2","3","4","5","6","7",
                    "8","9","A","B","C","D","E","F"]
        if(decimal < 16) {
            return digits[decimal]
        }
        return dtoh(decimal: decimal / 16) + digits[decimal % 16]
    }
    
    func hexTorgb(hex : String) -> (red : Int, green : Int, blue : Int) {
        let sRed = substring(tok: hex, begin: 0, end: 2)
        let sGreen = substring(tok: hex, begin: 2, end: 4)
        let sBlue = substring(tok: hex, begin: 4, end: 6)
        return (red : hexHelper(tok: sRed, p: 1), green : hexHelper(tok: sGreen, p: 1),blue : hexHelper(tok: sBlue, p: 1))
    }
    
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
    
    func substring(tok: String, begin : Int, end : Int) -> String {
        var count : Int = 0
        let tokArray = Array(tok)
        var retStr : String = ""
        for c in tokArray {
            if count >= begin && count < end {
                retStr += String(c)
            }
            count += 1
        }
        
        return retStr
    }
}
