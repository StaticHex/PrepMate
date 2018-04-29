//
//  SearchFilterPopoverViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/20/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class SearchFilterPopoverViewController: UIViewController {

    // UI Component Outlets
    @IBOutlet weak var chkTreeNut: UIButton!
    @IBOutlet weak var chkEggs: UIButton!
    @IBOutlet weak var chkMilk: UIButton!
    @IBOutlet weak var chkGluten: UIButton!
    @IBOutlet weak var chkMeat: UIButton!
    @IBOutlet weak var chkPork: UIButton!
    @IBOutlet weak var chkButter: UIButton!
    @IBOutlet weak var chkPeanuts: UIButton!
    @IBOutlet weak var chkShellfish: UIButton!
    @IBOutlet weak var chkTomato: UIButton!
    @IBOutlet weak var chkSoy: UIButton!
    @IBOutlet weak var chkFish: UIButton!
    @IBOutlet weak var chkYeast: UIButton!
    @IBOutlet weak var chkSpicy: UIButton!
    @IBOutlet weak var chkHealthy: UIButton!
    @IBOutlet weak var chkHighFat: UIButton!
    @IBOutlet weak var chkVegetarian: UIButton!
    @IBOutlet weak var chkVegan: UIButton!
    @IBOutlet weak var pckCategory: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Nav. Bar actions
    @IBAction func onApply(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        print("clicked!")
        self.dismiss(animated: true, completion: nil)
    }
    
    // Check Box Actions
    @IBAction func onTreeNutCheck(_ sender: Any) {
    }
    
    @IBAction func onEggCheck(_ sender: Any) {
    }
    
    
    @IBAction func onMilkCheck(_ sender: Any) {
    }
    
    @IBAction func onGlutenCheck(_ sender: Any) {
    }
    
    @IBAction func onMeatCheck(_ sender: Any) {
    }
    
    @IBAction func onPorkCheck(_ sender: Any) {
    }
    
    @IBAction func onButterCheck(_ sender: Any) {
    }
    
    @IBAction func onPeanutCheck(_ sender: Any) {
    }
    
    @IBAction func onShellfishCheck(_ sender: Any) {
    }
    
    @IBAction func onTomatoCheck(_ sender: Any) {
    }
    
    @IBAction func onSoyCheck(_ sender: Any) {
    }
    
    @IBAction func onFishCheck(_ sender: Any) {
    }
    
    @IBAction func onYeastCheck(_ sender: Any) {
    }
    
    @IBAction func onSpicyCheck(_ sender: Any) {
    }
    
    @IBAction func onHealthyCheck(_ sender: Any) {
    }
    
    @IBAction func onHFatCheck(_ sender: Any) {
    }
    
    @IBAction func onVegetarianCheck(_ sender: Any) {
    }
    
    @IBAction func onVeganCheck(_ sender: Any) {
    }
    
    // Info Actions, for alerts
    @IBAction func infoTreeNut(_ sender: Any) {
    }
    
    @IBAction func infoEgg(_ sender: Any) {
    }
    
    @IBAction func infoMilk(_ sender: Any) {
    }
    
    @IBAction func infoWheat(_ sender: Any) {
    }
    
    @IBAction func infoMeat(_ sender: Any) {
    }
    
    @IBAction func infoPork(_ sender: Any) {
    }
    
    @IBAction func infoButter(_ sender: Any) {
    }
    
    @IBAction func infoPeanuts(_ sender: Any) {
    }
    
    @IBAction func infoShellfish(_ sender: Any) {
    }
    
    @IBAction func infoTomato(_ sender: Any) {
    }
    
    @IBAction func infoSoy(_ sender: Any) {
    }
    
    @IBAction func infoFish(_ sender: Any) {
    }
    
    @IBAction func infoYeast(_ sender: Any) {
    }
    
    @IBAction func infoSpicy(_ sender: Any) {
    }
    
    @IBAction func infoHealthy(_ sender: Any) {
    }
    
    @IBAction func infoHFat(_ sender: Any) {
    }
    
    @IBAction func infoVegetarian(_ sender: Any) {
    }
    
    @IBAction func infoVegan(_ sender: Any) {
    }
    
}
