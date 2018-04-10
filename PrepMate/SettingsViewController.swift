//
//  SettingsViewController.swift
//  PrepMate
//
//  Created by Joseph Bourque on 3/18/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPopoverPresentationControllerDelegate, ColorPickProtocol {
    var currentUser = User()
    
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
    
    weak var sDelegate: settingsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        let defaults = UserDefaults.standard
        if let decoded = defaults.object(forKey: "remembered") as? Data {
            let status = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Bool
            if status {
                swtRemember.setOn(true, animated: false)
            } else {
                swtRemember.setOn(false, animated: false)
            }
        }
        if let decoded = defaults.object(forKey: "amPantry") as? Data {
            let status = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Bool
            if status {
                swtManagePantry.setOn(true, animated: false)
            } else {
                swtManagePantry.setOn(false, animated: false)
            }
        }
        if let decoded = defaults.object(forKey: "amSList") as? Data {
            let status = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Bool
            if status {
                swtManageSlist.setOn(true, animated: false)
            } else {
                swtManageSlist.setOn(false, animated: false)
            }
        }
    }

    @IBAction func setTitleColor(_ sender: Any) {
        // Color picker
    }
    
    @IBAction func setFontColor(_ sender: Any) {
        // Color picker
    }
    
    @IBAction func onAMPantryCheck(_ sender: Any) {
        let data = NSKeyedArchiver.archivedData(withRootObject: swtManagePantry.isOn)
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: "amPantry")
    }
    
    @IBAction func onAMSListCheck(_ sender: Any) {
        let data = NSKeyedArchiver.archivedData(withRootObject: swtManageSlist.isOn)
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: "amSList")
    }
    
    @IBAction func onRememberCheck(_ sender: Any) {
        let rData = NSKeyedArchiver.archivedData(withRootObject: swtRemember.isOn)
        let defaults = UserDefaults.standard
        defaults.set(rData, forKey: "remembered")
        if swtRemember.isOn {
            let unData = NSKeyedArchiver.archivedData(withRootObject: currentUser.getUname())
            let pData = NSKeyedArchiver.archivedData(withRootObject: currentUser.getPword())
            defaults.set(unData, forKey: "uname")
            defaults.set(pData, forKey: "pword")
        } else {
            let unData = NSKeyedArchiver.archivedData(withRootObject: "")
            let pData = NSKeyedArchiver.archivedData(withRootObject: "")
            defaults.set(unData, forKey: "uname")
            defaults.set(pData, forKey: "pword")
        }
    }
    
    // Update color scheme depending on if they selected font color or title color
    func updateColor(color : UIColor?, sender : Int) {
        
        let defaults = UserDefaults.standard
        
        // Change text color
        if (sender == 1) {
            btnFontColor.backgroundColor = color
            let color = btnFontColor.backgroundColor!
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: color)
            
            defaults.set(encodedData, forKey: "navBarTextColor")
            
            UINavigationBar.appearance().tintColor = color
            
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : color]
            
            UILabel.appearance().textColor = color
            
            
            unitsLabel.textColor = color
            pantryLabel.textColor = color
            shoppingLabel.textColor = color
            userLabel.textColor = color
            titleLabel.textColor = color
            fontLabel.textColor = color
            self.navigationController?.navigationBar.tintColor = color
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : color]
            
        } else {
            // Change title background color
            btnTitleColor.backgroundColor = color
            let color = btnTitleColor.backgroundColor!
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: color)
            
            defaults.set(encodedData, forKey: "titleBarColor")
            UINavigationBar.appearance().backgroundColor = color
            self.navigationController?.navigationBar.backgroundColor = color
            sDelegate?.changeSidebarColor(color: color)
            
        }
        
    }
    
}
