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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func setTitleColor(_ sender: Any) {
    }
    
    @IBAction func setFontColor(_ sender: Any) {
    }
    
    @IBAction func setStarColor1(_ sender: Any) {
    }
    
    @IBOutlet weak var setStarColor2: UIButton!
    
}
