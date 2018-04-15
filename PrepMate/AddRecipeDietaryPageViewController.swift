//
//  AddRecipeDietaryPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit


// Used by the bitvector for flags
var dietaryVector: [Bool] = [false, false, false, false, false, false, false]

class AddRecipeDietaryPageViewController: UIViewController {

    weak var dDelegate: firstPageProtocol?

    
    var dietaryVectorCopy: [Bool] = dietaryVector

    
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
        self.dietaryVectorCopy = dietaryVector
        
        if dietaryVector[0] {
            spicyButton.setTitle("■", for: .normal)
        }
        if dietaryVector[1] {
            healthyButton.setTitle("■", for: .normal)
        }
        if dietaryVector[2] {
            highFatButton.setTitle("■", for: .normal)
        }
        if dietaryVector[3] {
            veganButton.setTitle("■", for: .normal)
        }
        if dietaryVector[4] {
            vegetarianButton.setTitle("■", for: .normal)
        }
        if dietaryVector[5] {
            kosherButton.setTitle("■", for: .normal)
        }
        if dietaryVector[6] {
            lowCarbButton.setTitle("■", for: .normal)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Following functions help set up the bit vector  for the dietary information
    @IBAction func spicy(_ sender: Any) {
        if spicyButton.currentTitle == "■" {
            dietaryVectorCopy[0] = false
            spicyButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVectorCopy[0] = true
            spicyButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func healthy(_ sender: Any) {
        if healthyButton.currentTitle == "■" {
            dietaryVectorCopy[1] = false
            healthyButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVectorCopy[1] = true
            healthyButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func highFat(_ sender: Any) {
        if highFatButton.currentTitle == "■" {
            dietaryVectorCopy[2] = false
            highFatButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVectorCopy[2] = true
            highFatButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func vegan(_ sender: Any) {
        if veganButton.currentTitle == "■" {
            dietaryVectorCopy[3] = false
            veganButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVectorCopy[3] = true
            veganButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func vegetarian(_ sender: Any) {
        if vegetarianButton.currentTitle == "■" {
            dietaryVectorCopy[4] = false
            vegetarianButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVectorCopy[4] = true
            vegetarianButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func kosher(_ sender: Any) {
        if kosherButton.currentTitle == "■" {
            dietaryVectorCopy[5] = false
            kosherButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVectorCopy[5] = true
            kosherButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func lowCarb(_ sender: Any) {
        if lowCarbButton.currentTitle == "■" {
            dietaryVectorCopy[6] = false
            lowCarbButton.setTitle("□", for: .normal)
        }
        else {
            dietaryVectorCopy[6] = true
            lowCarbButton.setTitle("■", for: .normal)
        }
    }
    
    // Save the dietary portion of the bit vector and pass it back to the first page add recipe controller
    @IBAction func save(_ sender: Any) {
        dietaryVector = dietaryVectorCopy
        dDelegate?.dietary(dietaryItem: dietaryVector)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func discard(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
