//
//  SettingsViewController.swift
//  PrepMate
//
//  Created by Joseph Bourque on 3/18/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    // UI Component Outlets
    @IBOutlet weak var swtManagePantry: UISwitch!
    @IBOutlet weak var swtManageSlist: UISwitch!
    @IBOutlet weak var swtRemember: UISwitch!
    @IBOutlet weak var swtWarnCustom: UISwitch!
    @IBOutlet weak var btnTitleColor: UIButton!
    @IBOutlet weak var btnFontColor: UIButton!
    @IBOutlet weak var btnStarColor1: UIButton!
    @IBOutlet weak var btnStarColor2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func setTitleColor(_ sender: Any) {
    }
    
    @IBAction func setFontColor(_ sender: Any) {
    }
    
    @IBAction func setStarColor1(_ sender: Any) {
    }
    
    @IBOutlet weak var setStarColor2: UIButton!
    
}
