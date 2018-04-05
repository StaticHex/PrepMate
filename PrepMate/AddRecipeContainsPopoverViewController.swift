//
//  AddRecipeContainsPopoverViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class AddRecipeContainsPopoverViewController: UIViewController {

    
    weak var cDelegate: firstPageProtocol?
    
    // Bit vector information for the Contains portion
    var vector: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false]
    
    // Button outlets
    @IBOutlet weak var treeNutsButton: UIButton!
    @IBOutlet weak var eggsButton: UIButton!
    @IBOutlet weak var milkButton: UIButton!
    @IBOutlet weak var glutenButton: UIButton!
    @IBOutlet weak var meatButton: UIButton!
    @IBOutlet weak var porkButton: UIButton!
    @IBOutlet weak var butterButton: UIButton!
    @IBOutlet weak var peanutsButton: UIButton!
    @IBOutlet weak var shellfishButton: UIButton!
    @IBOutlet weak var tomatoesButton: UIButton!
    @IBOutlet weak var soyButton: UIButton!
    @IBOutlet weak var fishButton: UIButton!
    @IBOutlet weak var yeastButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Following functions help set up the bit vector  for the Contains information
    @IBAction func treeNuts(_ sender: Any) {
        if treeNutsButton.currentTitle == "■" {
            treeNutsButton.setTitle("□", for: .normal)
        }
        else {
            vector[0] = true
            treeNutsButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func eggs(_ sender: Any) {
        if eggsButton.currentTitle == "■" {
            eggsButton.setTitle("□", for: .normal)
        }
        else {
            vector[1] = true
            eggsButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func milk(_ sender: Any) {
        if milkButton.currentTitle == "■" {
            milkButton.setTitle("□", for: .normal)
        }
        else {
            vector[2] = true
            milkButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func gluten(_ sender: Any) {
        if glutenButton.currentTitle == "■" {
            glutenButton.setTitle("□", for: .normal)
        }
        else {
            vector[3] = true
            glutenButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func meat(_ sender: Any) {
        if meatButton.currentTitle == "■" {
            meatButton.setTitle("□", for: .normal)
        }
        else {
            vector[4] = true
            meatButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func pork(_ sender: Any) {
        if porkButton.currentTitle == "■" {
            porkButton.setTitle("□", for: .normal)
        }
        else {
            vector[5] = true
            porkButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func butter(_ sender: Any) {
        if butterButton.currentTitle == "■" {
            butterButton.setTitle("□", for: .normal)
        }
        else {
            vector[6] = true
            butterButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func peanuts(_ sender: Any) {
        if peanutsButton.currentTitle == "■" {
            peanutsButton.setTitle("□", for: .normal)
        }
        else {
            vector[7] = true
            peanutsButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func shellfish(_ sender: Any) {
        if shellfishButton.currentTitle == "■" {
            shellfishButton.setTitle("□", for: .normal)
        }
        else {
            vector[8] = true
            shellfishButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func tomatoes(_ sender: Any) {
        if tomatoesButton.currentTitle == "■" {
            tomatoesButton.setTitle("□", for: .normal)
        }
        else {
            vector[9] = true
            tomatoesButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func soy(_ sender: Any) {
        if soyButton.currentTitle == "■" {
            soyButton.setTitle("□", for: .normal)
        }
        else {
            vector[10] = true
            soyButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func fish(_ sender: Any) {
        if fishButton.currentTitle == "■" {
            fishButton.setTitle("□", for: .normal)
        }
        else {
            vector[11] = true
            fishButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func yeast(_ sender: Any) {
        if yeastButton.currentTitle == "■" {
            yeastButton.setTitle("□", for: .normal)
        }
        else {
            vector[12] = true
            yeastButton.setTitle("■", for: .normal)
        }
    }
    
    // Save the Contains portion of the bit vector and pass it back to the first page add recipe controller
    @IBAction func save(_ sender: Any) {
        cDelegate?.contains(containsItem: vector)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func discard(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
}
