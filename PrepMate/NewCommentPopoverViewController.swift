//
//  NewCommentPopoverViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit
protocol addCommentProtocol : class {
    func addComment(comment: Comment)
}
class NewCommentPopoverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    /// Outlet for the comment body
    @IBOutlet weak var commentBody: UITextView!
    /// Outlet for the title text field
    @IBOutlet weak var titleTextField: UITextField!
    /// Outlet to display chosen rating
    @IBOutlet weak var ratingsPickerField: UIImageView!
    /// Variable that keeps track of the selected rating
    var ratingsRow = 0
    
    /// Ratings picker
    var ratingsPicker = UIPickerView()
    
    weak var addCommentDelegate: addCommentProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ratingsPicker.delegate = self
        self.ratingsPicker.dataSource = self
        ratingsPickerField.image = RatingImages[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPressSave(_ sender: Any) {
        if titleTextField.text! == "" {
            self.commentAlert(str: "Title")
            return
        }
        if commentBody.text! == "" {
            self.commentAlert(str: "Comment Body")
            return
        }
        addCommentDelegate?.addComment(comment: Comment(id: -1, title: titleTextField.text!, author: currentUser, rating: ratingsRow, description: commentBody.text!))
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onPressDiscard(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RatingImages.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.ratingsRow = row
        ratingsPickerField.image = RatingImages[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return UIImageView(image: RatingImages[row])
    }
    func commentAlert(str:String) {
        let alert = UIAlertController(title: "Add Comment Error", message: "\(str) field cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
