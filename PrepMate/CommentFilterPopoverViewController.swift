//
//  CommentFilterPopoverViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit
// Sort Comment Protocol
// @description
// - Protocol used to send back information about how to sort comments
protocol sortCommentProtocol: class {
    func sortDate(enabledStars: [Bool], sortOption: Int)
    func sortRating(enabledStars:[Bool], sortOption: Int)
}
// Comment Filter Popover that gives the user the ability to sort recipe comments
class CommentFilterPopoverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Button to enable different star ratings
    @IBOutlet weak var oneStarButton: UIButton!
    @IBOutlet weak var twoStarButton: UIButton!
    @IBOutlet weak var threeStarButton: UIButton!
    @IBOutlet weak var fourStarButton: UIButton!
    @IBOutlet weak var fiveStarButton: UIButton!
    // Holds the enabled title
    let enabled = "■"
    // Holds the disabled title
    let notEnabled = "□"
    // Bool array that specifies which stars to enable
    var starSortVector = [false, false, false, false, false]
    // Input view for the picker
    @IBOutlet weak var sortPickerText: UITextField!
    // Picker that allows users to sort comments in various ways
    var sortByPicker = UIPickerView()
    // Array that holds all picker sort by options
    let sortOptions = ["Most Recent", "Oldest", "Highest Rating", "Lowest Rating"]
    // Holds the index of the selected option
    var selectedOption = 0
    // Protocol delegate variable
    var sortCommentDelegate: sortCommentProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortByPicker.delegate = self
        sortByPicker.dataSource = self
        // Set up the picker textfield to be the inputview for the picker
        sortPickerText.inputView = sortByPicker
        sortPickerText.text = sortOptions[selectedOption]
        // Enable and disable the buttons based on the `starSortVector`
        if(starSortVector[0]){
            oneStarButton.setTitle(enabled, for: .normal)
        } else {
            oneStarButton.setTitle(notEnabled, for: .normal)
        }
        if(starSortVector[0]){
            oneStarButton.setTitle(enabled, for: .normal)
        } else {
            oneStarButton.setTitle(notEnabled, for: .normal)
        }

        if(starSortVector[1]){
            twoStarButton.setTitle(enabled, for: .normal)
        } else {
            twoStarButton.setTitle(notEnabled, for: .normal)
        }

        if(starSortVector[2]){
            threeStarButton.setTitle(enabled, for: .normal)
        } else {
            threeStarButton.setTitle(notEnabled, for: .normal)
        }

        if(starSortVector[3]){
            fourStarButton.setTitle(enabled, for: .normal)
        } else {
            fourStarButton.setTitle(notEnabled, for: .normal)
        }
        
        if(starSortVector[4]){
            fiveStarButton.setTitle(enabled, for: .normal)
        } else {
            fiveStarButton.setTitle(notEnabled, for: .normal)
        }
        
    }
    // Required function for the UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // Required function for the UIPickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOptions.count
    }
    // Required function for the UIPickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOptions[row]
    }
    // Requried function for the UIPickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sortPickerText.text = sortOptions[row]
        self.selectedOption = row
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Function that toggles star button on click
    @IBAction func oneStar(_ sender: Any) {
        if oneStarButton.currentTitle == "■" {
            starSortVector[0] = false
            oneStarButton.setTitle("□", for: .normal)
        }
        else {
            starSortVector[0] = true
           oneStarButton.setTitle("■", for: .normal)
        }
    }
    // Function that toggles star button on click
    @IBAction func twoStar(_ sender: Any) {
        if twoStarButton.currentTitle == "■" {
            starSortVector[1] = false
            twoStarButton.setTitle("□", for: .normal)
        }
        else {
            starSortVector[1] = true
            twoStarButton.setTitle("■", for: .normal)
        }
    }
    // Function that toggles star button on click
    @IBAction func threeStar(_ sender: Any) {
        if threeStarButton.currentTitle == "■" {
            starSortVector[2] = false
            threeStarButton.setTitle("□", for: .normal)
        }
        else {
            starSortVector[2] = true
            threeStarButton.setTitle("■", for: .normal)
        }
    }
    // Function that toggles star button on click
    @IBAction func fourStar(_ sender: Any) {
        if fourStarButton.currentTitle == "■" {
            starSortVector[3] = false
            fourStarButton.setTitle("□", for: .normal)
        }
        else {
            starSortVector[3] = true
            fourStarButton.setTitle("■", for: .normal)
        }
    }
    // Function that toggles star button on click
    @IBAction func fiveStar(_ sender: Any) {
        if fiveStarButton.currentTitle == "■" {
            starSortVector[4] = false
            fiveStarButton.setTitle("□", for: .normal)
        }
        else {
            starSortVector[4] = true
            fiveStarButton.setTitle("■", for: .normal)
        }
    }
    // Function that applies the new comment filter by passing the relevant info back to the recipe comment page
    @IBAction func onSortPressed(_ sender: Any) {
        if(selectedOption <= 1){
            // Sort by date
            self.sortCommentDelegate?.sortDate(enabledStars: starSortVector, sortOption: selectedOption)
        } else {
            // Sort by rating
            self.sortCommentDelegate?.sortRating(enabledStars: starSortVector, sortOption: selectedOption)
        }
        dismiss(animated: true, completion: nil)
    }
    // Dismisses the popover on cancel
    @IBAction func onCancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /// Resets comment filter to the default values
    @IBAction func onReset(_ sender: Any) {
        starSortVector = [true, true, true, true, true]
        oneStarButton.setTitle("■", for: .normal)
        twoStarButton.setTitle("■", for: .normal)
        threeStarButton.setTitle("■", for: .normal)
        fourStarButton.setTitle("■", for: .normal)
        fiveStarButton.setTitle("■", for: .normal)
        self.selectedOption = 0
    }
    

}
