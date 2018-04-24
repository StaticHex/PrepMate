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
    @IBOutlet weak var ratingsTextField: UITextField!
    var ratingsPicker = UIPickerView()
    var ratingOptions = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]
    var selectedRating = 0

    weak var addCommentDelegate: addCommentProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentBody.layer.borderWidth = 1
        self.ratingsPicker.delegate = self
        self.ratingsPicker.dataSource = self
        self.ratingsTextField.inputView = ratingsPicker
        self.ratingsTextField.text = String(ratingOptions[0])
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
        // TODO: Comment id?
        var newComment = Comment()
        newComment.title = titleTextField.text!
        newComment.description = commentBody.text!
        newComment.rating = selectedRating
        newComment.userId = currentUser.getId()
        newComment.date = getTimestamp()
        addCommentDelegate?.addComment(comment: newComment)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onPressDiscard(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratingOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRating = row
        self.ratingsTextField.text = String(ratingOptions[row])
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(ratingOptions[row])
    }
    func commentAlert(str:String) {
        let alert = UIAlertController(title: "Add Comment Error", message: "\(str) field cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
