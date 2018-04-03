//
//  SettingsViewController.swift
//  PrepMate
//
//  Created by Joseph Bourque on 3/18/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPopoverPresentationControllerDelegate, ColorPickProtocol {
    // UI Component Outlets
    @IBOutlet weak var swtManagePantry: UISwitch!
    @IBOutlet weak var swtManageSlist: UISwitch!
    @IBOutlet weak var swtRemember: UISwitch!
    @IBOutlet weak var btnTitleColor: UIButton!
    @IBOutlet weak var btnFontColor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        btnTitleColor.layer.borderColor = UIColor.black.cgColor
        btnTitleColor.layer.borderWidth = 1
        btnFontColor.layer.borderColor = UIColor.black.cgColor
        btnFontColor.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "bgColorPopover"
            || segue.identifier == "fontColorPopover") {
            let vc = segue.destination as? ColorPickerViewController
            if(segue.identifier == "bgColorPopover") {
                vc?.whichBox = 0
            } else {
                vc?.whichBox = 1
            }
            vc?.colorDelegate = self
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func setTitleColor(_ sender: Any) {
        let defaults = UserDefaults.standard
        let color = UIColor(red: 100/255.0, green: 100.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: color)

        defaults.set(encodedData, forKey: "titleBarColor")
        UINavigationBar.appearance().backgroundColor = color
        
        // Nav Bar Item Colors
        UINavigationBar.appearance().tintColor = color
        // Navigation Bar Text
    }
    
    @IBAction func setFontColor(_ sender: Any) {
        let defaults = UserDefaults.standard
        let color = UIColor(red: 20.0/255.0, green: 50.0/255.0, blue: 130.0/255.0, alpha: 1.0)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: color)
        
        defaults.set(encodedData, forKey: "navBarTextColor")
        
        // Nav Bar Item Colors
        UINavigationBar.appearance().tintColor = color
        
        // Nav Bar Text
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : color]
//        UILabel.appearance().textColor = UIColor.red
    }
    
    func updateColor(color : UIColor?, sender : Int) {
        if (sender == 1) {
            btnFontColor.backgroundColor = color
        } else {
            btnTitleColor.backgroundColor = color
        }
    }
    
}
