//
//  AddRecipeContainsPopoverViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

var containsVector: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false]

class AddRecipeContainsPopoverViewController: UIViewController {

    
    weak var cDelegate: firstPageProtocol?
    
    // Bit vector information for the Contains portion
    var vectorCopy: [Bool] = containsVector
    
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

        self.vectorCopy = containsVector
        
        if containsVector[0] {
            treeNutsButton.setTitle("■", for: .normal)
        }
        if containsVector[1] {
            eggsButton.setTitle("■", for: .normal)
        }
        if containsVector[2] {
            milkButton.setTitle("■", for: .normal)
        }
        if containsVector[3] {
            glutenButton.setTitle("■", for: .normal)
        }
        if containsVector[4] {
            meatButton.setTitle("■", for: .normal)
        }
        if containsVector[5] {
            porkButton.setTitle("■", for: .normal)
        }
        if containsVector[6] {
            butterButton.setTitle("■", for: .normal)
        }
        if containsVector[7] {
            peanutsButton.setTitle("■", for: .normal)
        }
        if containsVector[8] {
            shellfishButton.setTitle("■", for: .normal)
        }
        if containsVector[9] {
            tomatoesButton.setTitle("■", for: .normal)
        }
        if containsVector[10] {
            soyButton.setTitle("■", for: .normal)
        }
        if containsVector[11] {
            fishButton.setTitle("■", for: .normal)
        }
        if containsVector[12] {
            yeastButton.setTitle("■", for: .normal)
        }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Following functions help set up the bit vector  for the Contains information
    @IBAction func treeNuts(_ sender: Any) {
        if treeNutsButton.currentTitle == "■" {
            vectorCopy[0] = false
            treeNutsButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[0] = true
            treeNutsButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func eggs(_ sender: Any) {
        if eggsButton.currentTitle == "■" {
            vectorCopy[1] = false
            eggsButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[1] = true
            eggsButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func milk(_ sender: Any) {
        if milkButton.currentTitle == "■" {
            vectorCopy[2] = false
            milkButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[2] = true
            milkButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func gluten(_ sender: Any) {
        if glutenButton.currentTitle == "■" {
            vectorCopy[3] = false
            glutenButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[3] = true
            glutenButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func meat(_ sender: Any) {
        if meatButton.currentTitle == "■" {
            vectorCopy[4] = false
            meatButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[4] = true
            meatButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func pork(_ sender: Any) {
        if porkButton.currentTitle == "■" {
            vectorCopy[5] = false
            porkButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[5] = true
            porkButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func butter(_ sender: Any) {
        if butterButton.currentTitle == "■" {
            vectorCopy[6] = false
            butterButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[6] = true
            butterButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func peanuts(_ sender: Any) {
        if peanutsButton.currentTitle == "■" {
            vectorCopy[7] = false
            peanutsButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[7] = true
            peanutsButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func shellfish(_ sender: Any) {
        if shellfishButton.currentTitle == "■" {
            vectorCopy[8] = false
            shellfishButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[8] = true
            shellfishButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func tomatoes(_ sender: Any) {
        if tomatoesButton.currentTitle == "■" {
            vectorCopy[9] = false
            tomatoesButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[9] = true
            tomatoesButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func soy(_ sender: Any) {
        if soyButton.currentTitle == "■" {
            vectorCopy[10] = false
            soyButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[10] = true
            soyButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func fish(_ sender: Any) {
        if fishButton.currentTitle == "■" {
            vectorCopy[11] = false
            fishButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[11] = true
            fishButton.setTitle("■", for: .normal)
        }
    }
    @IBAction func yeast(_ sender: Any) {
        if yeastButton.currentTitle == "■" {
            vectorCopy[12] = false
            yeastButton.setTitle("□", for: .normal)
        }
        else {
            vectorCopy[12] = true
            yeastButton.setTitle("■", for: .normal)
        }
    }
    
    // Save the Contains portion of the bit vector and pass it back to the first page add recipe controller
    @IBAction func save(_ sender: Any) {
        containsVector = self.vectorCopy
        cDelegate?.contains(containsItem: containsVector)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func discard(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
}
