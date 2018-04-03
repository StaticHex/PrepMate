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
    
    @IBOutlet weak var pantryLabel: UILabel!
    @IBOutlet weak var shoppingLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    
    
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
        // Color picker
    }
    
    @IBAction func setFontColor(_ sender: Any) {
        // Color picker
    }
    
    func updateColor(color : UIColor?, sender : Int) {
        
        // Should have a default color scheme to set it back to original?
        
        let defaults = UserDefaults.standard
        if (sender == 1) {
            btnFontColor.backgroundColor = color
            let color = btnFontColor.backgroundColor!
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: color)
            
            defaults.set(encodedData, forKey: "navBarTextColor")
            
            // Nav Bar Item Colors
            UINavigationBar.appearance().tintColor = color
            
            // Nav Bar Text
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : color]
            // UILabel.appearanceWhenContainedInInstancesOfClasses([MyViewController.self, MyotherViewController.self]).textColor = UIColor.red

            UILabel.appearance().textColor = color
            // Makes all buttons same color (issue: color change when pressed. Possible for all buttons to be fixed at once?
            UIButton.appearance().tintColor = color
            
            
            unitsLabel.textColor = color
            pantryLabel.textColor = color
            shoppingLabel.textColor = color
            userLabel.textColor = color
            titleLabel.textColor = color
            fontLabel.textColor = color
            self.navigationController?.navigationBar.tintColor = color
            
        } else {
            btnTitleColor.backgroundColor = color
            let color = btnTitleColor.backgroundColor!
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: color)
            
            defaults.set(encodedData, forKey: "titleBarColor")
            // Nav Bar Color
            UINavigationBar.appearance().backgroundColor = color
            // Trying to change nav bar color on change (cannot currently with the right alpha/scheme)
        }
        
    }
    
}
