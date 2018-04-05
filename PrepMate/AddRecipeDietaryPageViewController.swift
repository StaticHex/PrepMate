//
//  AddRecipeDietaryPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class AddRecipeDietaryPageViewController: UIViewController {

    weak var dDelegate: firstPageProtocol?
    
    // Used by the bitvector for flags
    var dietaryVector: [Bool] = [false, false, false, false, false, false, false]
    
    // Outlets
    @IBOutlet weak var spicyButton: UIButton!
    @IBOutlet weak var healthyButton: UIButton!
    @IBOutlet weak var highFatButton: UIButton!
    @IBOutlet weak var veganButton: UIButton!
    @IBOutlet weak var vegetarianButton: UIButton!
    @IBOutlet weak var kosherButton: UIButton!
    @IBOutlet weak var lowCarbButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Following functions help set up the bit vector  for the dietary information
    @IBAction func spicy(_ sender: Any) {
        if spicyButton.currentTitle == "■" {
            spicyButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVector[0] = true
            spicyButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func healthy(_ sender: Any) {
        if healthyButton.currentTitle == "■" {
            healthyButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVector[1] = true
            healthyButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func highFat(_ sender: Any) {
        if highFatButton.currentTitle == "■" {
            highFatButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVector[2] = true
            highFatButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func vegan(_ sender: Any) {
        if veganButton.currentTitle == "■" {
            veganButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVector[3] = true
            veganButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func vegetarian(_ sender: Any) {
        if vegetarianButton.currentTitle == "■" {
            vegetarianButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVector[4] = true
            vegetarianButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func kosher(_ sender: Any) {
        if kosherButton.currentTitle == "■" {
            kosherButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVector[5] = true
            kosherButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func lowCarb(_ sender: Any) {
        if lowCarbButton.currentTitle == "■" {
            lowCarbButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVector[6] = true
            lowCarbButton.setTitle("■", for: .normal)
        }
    }
    
    // Save the dietary portion of the bit vector and pass it back to the first page add recipe controller
    @IBAction func save(_ sender: Any) {
        dDelegate?.dietary(dietaryItem: dietaryVector)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func discard(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
