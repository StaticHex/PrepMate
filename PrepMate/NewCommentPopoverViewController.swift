//
//  NewCommentPopoverViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit
// Add Comment Protocol
// @description
// - A Protocol that contains functions to add a new comment to the Recipe Comment page
protocol addCommentProtocol : class {
    func addComment(comment: Comment)
}
// A Popover view that allows the user to add a new comment to a recipe
class NewCommentPopoverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // Outlet for the comment body
    @IBOutlet weak var commentBody: UITextView!
    // Outlet for the title text field
    @IBOutlet weak var titleTextField: UITextField!
    // Inputview for the ratings picker
    @IBOutlet weak var ratingsTextField: UITextField!
    // Picker for the ratings
    var ratingsPicker = UIPickerView()
    // An array of rating options for the ratings picker
    var ratingOptions = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]
    // Holds the index of the selected rating
    var selectedRating = 0

    weak var addCommentDelegate: addCommentProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Draw a border around the comment body
        self.commentBody.layer.borderWidth = 1
        self.ratingsPicker.delegate = self
        self.ratingsPicker.dataSource = self
        // Set up the ratingsTextField as the inputview for the ratings picker
        self.ratingsTextField.inputView = ratingsPicker
        self.ratingsTextField.text = String(ratingOptions[0])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Function that adds the newly created comment when save is clicked
    @IBAction func onPressSave(_ sender: Any) {
        // Make sure the title and comment body are not empty
        if titleTextField.text! == "" {
            self.commentAlert(str: "Title")
            return
        }
        if commentBody.text! == "" {
            self.commentAlert(str: "Comment Body")
            return
        }
        // Create a new comment and send to the Recipe Comments page
        var newComment = Comment()
        newComment.title = titleTextField.text!
        newComment.description = commentBody.text!
        newComment.rating = selectedRating
        newComment.userId = currentUser.getId()
        newComment.date = getTimestamp()
        addCommentDelegate?.addComment(comment: newComment)
        dismiss(animated: true, completion: nil)
    }
    // Dismiss the popover on discard
    @IBAction func onPressDiscard(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // Required function for UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // Required function for UIPickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratingOptions.count
    }
    // Required function for UIPickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRating = row
        self.ratingsTextField.text = String(ratingOptions[row])
    }
    // Required function for UIPickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(ratingOptions[row])
    }
    // Comment Alert Function
    // @params
    // - str: (String) The alert message to display
    // @description
    // - Alerts the user with a specified message
    func commentAlert(str:String) {
        let alert = UIAlertController(title: "Add Comment Error", message: "\(str) field cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
