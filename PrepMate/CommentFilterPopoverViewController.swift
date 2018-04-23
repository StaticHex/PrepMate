//
//  CommentFilterPopoverViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit
protocol sortCommentProtocol: class {
    func sortDate(ascend:Bool, enabledStars: [Bool], sortOption: Int)
    func sortRating(ascend: Bool, enabledStars:[Bool], sortOption: Int)
}
class CommentFilterPopoverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var oneStarButton: UIButton!
    @IBOutlet weak var twoStarButton: UIButton!
    @IBOutlet weak var threeStarButton: UIButton!
    @IBOutlet weak var fourStarButton: UIButton!
    @IBOutlet weak var fiveStarButton: UIButton!
    var starSortVector = [false, false, false, false, false]
    @IBOutlet weak var sortPickerText: UITextField!
    var sortByPicker = UIPickerView()
    let sortOptions = ["Most Recent", "Oldest", "Highest Rating", "Lowest Rating"]
    var selectedOption = 0
    var sortCommentDelegate: sortCommentProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortByPicker.delegate = self
        sortByPicker.dataSource = self
        sortPickerText.inputView = sortByPicker
        sortPickerText.text = sortOptions[0]
        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOptions[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sortPickerText.text = sortOptions[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    @IBAction func onSortPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
