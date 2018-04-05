//
//  UserProfileViewController.swift
//  PrepMate
//
//  Created by Joseph Bourque on 3/17/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol ProfileProtocol : class {
    func updateUser(newUser : User)
}
class UserProfileViewController: UIViewController, UIPopoverPresentationControllerDelegate, URLProtocol {
    // ProfileProtocol Delegate
    weak var profileDelegate : ProfileProtocol?
    
    // Set up our alert controller herer
    let alert = UIAlertController(title: "",
                                  message: "",
                                  preferredStyle: .alert)
    
    // add = 0, edit = 1, view = 2, unset = -1
    var op : Int = -1
    var isPhotoSet : Bool = false
    var currentUser : User = User()
    var avatarPhoto : Photo = Photo()
    // UI Component outlets
    @IBOutlet weak var btnAvatar: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPword: UITextField!
    @IBOutlet weak var txtVPword: UITextField!
    @IBOutlet weak var tvBlacklist: UITableView!
    @IBOutlet weak var txtPrefferences: UITextView!
    @IBOutlet weak var txtBio: UITextView!
    @IBOutlet weak var btnAddBlistItem: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var stkPwordStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        btnAvatar.layer.backgroundColor = UIColor.white.cgColor
        // When view appears, hide and adjust UI components based on
        // whether we're adding, updating, or just viewing the user
        switch(op) {
        case 0: // add
            btnAvatar.setImage(#imageLiteral(resourceName: "2000px-Silver_-_replace_this_image_male.svg.png"), for: .normal)
            txtUserName.isEnabled = true
            txtUserName.text = ""
            txtFName.isEnabled = true
            txtFName.text = ""
            txtLName.isEnabled = true
            txtLName.text = ""
            txtEmail.isEnabled = true
            txtEmail.text = ""
            txtBio.isEditable = true
            txtBio.text = ""
            txtBio.isSelectable = true
            tvBlacklist.isHidden = false
            txtPrefferences.isHidden = true
            btnAddBlistItem.isHidden = false
            btnSave.isHidden = false
            btnCancel.isHidden = false
            stkPwordStack.isHidden = false
            break
        case 1: // edit
            btnAvatar.setImage(currentUser.getPhoto(), for: .normal)
            txtUserName.text = currentUser.getUname()
            txtUserName.isEnabled = false
            txtFName.text = currentUser.getFname()
            txtFName.isEnabled = true
            txtLName.text = currentUser.getLname()
            txtLName.isEnabled = true
            txtPword.text = currentUser.getPword()
            txtVPword.text = currentUser.getPword()
            txtEmail.text = currentUser.getEmail()
            txtEmail.isEnabled = true
            txtBio.text = currentUser.getBio()
            txtBio.isEditable = true
            txtBio.isSelectable = true
            tvBlacklist.isHidden = false
            txtPrefferences.isHidden = true
            btnAddBlistItem.isHidden = false
            btnSave.isHidden = false
            btnCancel.isHidden = false
            stkPwordStack.isHidden = false
            break
        case 2: // view
            btnAvatar.setImage(currentUser.getPhoto(), for: .normal)
            txtUserName.text = currentUser.getUname()
            txtUserName.isEnabled = false
            txtFName.text = currentUser.getFname()
            txtFName.isEnabled = true
            txtLName.text = currentUser.getLname()
            txtLName.isEnabled = true
            txtEmail.text = currentUser.getEmail()
            txtEmail.isEnabled = true
            txtBio.text = currentUser.getBio()
            txtBio.isEditable = true
            txtBio.isSelectable = true
            tvBlacklist.isHidden = true
            txtPrefferences.isHidden = false
            txtPrefferences.isSelectable = false
            txtPrefferences.isEditable = false
            btnAddBlistItem.isHidden = true
            btnSave.isHidden = true
            btnCancel.isHidden = true
            stkPwordStack.isHidden = true
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "userPhotoPopover") {
            let vc = segue.destination as? AddURLViewController
            vc?.urlDelegate = self
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
            }
        } else if(segue.identifier == "addBlistItemPopover") {
            let vc = segue.destination as? AddBlacklistViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
            }
        }
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func onAvatarClick(_ sender: Any) {
    }
    
    @IBAction func onAddBlist(_ sender: Any) {
    }
    
    @IBAction func onSaveClick(_ sender: Any) {
        // hold these here so we can loop through them
        let validation = [txtUserName, txtEmail, txtPword, txtVPword]
        var isInputValid : Bool = true // check to ensure no empty fields
        var pwordMatch : Bool = true // check to ensure passwords match
        var isPhotoSet : Bool = false // check to ensure photo is set
        var count : Int = 0
        for v in validation {
            if v?.text! == "" {
                isInputValid = false
                v?.layer.borderColor = UIColor.red.cgColor
                v?.layer.borderWidth = 1.0
            } else {
                v?.layer.borderColor = UIColor.black.cgColor
                v?.layer.borderWidth = 0.0
            }
            count+=1
        }
        if !isInputValid {
            alert.title = "Missing required information"
            alert.message = "You must provide a valid username, password, email, and profile picture to register\n\nNote: Failure to provide a valid email will make it unable for you to recover your password and could result in escalation of disciplinary action in the event of a violation of terms of service."
            self.present(alert, animated: true)
        } else if(txtPword.text! != txtVPword.text) {
            alert.title = "Passwords do not match"
            alert.message = "Please retype your password again or choose a new password"
            self.present(alert, animated: true)
            pwordMatch = false
        }
        if(avatarPhoto.getPath()=="") {
            isPhotoSet = false
            btnAvatar.layer.borderColor = UIColor.red.cgColor
            btnAvatar.layer.borderWidth = 1.0
        } else {
            isPhotoSet = true
            btnAvatar.layer.borderColor = UIColor.black.cgColor
            btnAvatar.layer.borderWidth = 0.0
        }
        
        if isInputValid && isPhotoSet && pwordMatch {
            // Reset properties of required fields
            txtUserName.layer.borderColor = UIColor.black.cgColor
            txtUserName.layer.borderWidth = 0.0
            txtEmail.layer.borderColor = UIColor.black.cgColor
            txtEmail.layer.borderWidth = 0.0
            txtPword.layer.borderColor = UIColor.black.cgColor
            txtPword.layer.borderWidth = 0.0
            txtVPword.layer.borderColor = UIColor.black.cgColor
            txtVPword.layer.borderWidth = 0.0
            btnAvatar.layer.borderColor = UIColor.black.cgColor
            btnAvatar.layer.borderWidth = 0.0
            
            if op == 0 {
                // Try to add our user, if an error occurs, display an alert with
                // an error message
                if(!currentUser.addUser(newUser: (uname: txtUserName.text!, pword: txtPword.text!, photo: avatarPhoto, fname: txtFName.text!, lname: txtLName.text!, email: txtEmail.text!, bio: txtBio.text!))) {
                    profileDelegate?.updateUser(newUser: currentUser)
                } else {
                    alert.title = "User Not Added"
                    alert.message = currentUser.getEMsg()
                    self.present(alert, animated: true)
                }

            } else if op == 1 {
                // Try to update our user, if an error occurs, display an alert with
                // an error message
                if(!currentUser.updateUser(newUser: (uname: txtUserName.text!, pword: txtPword.text!, photo: avatarPhoto, fname: txtFName.text!, lname: txtLName.text!, email: txtEmail.text!, bio: txtBio.text!))) {
                    profileDelegate?.updateUser(newUser: currentUser)
                } else {
                    alert.title = "User Not Updated"
                    alert.message = currentUser.getEMsg()
                    self.present(alert, animated: true)
                }
            }
        }
    }

    // This method is called when the user touches the Return key on the
    // keyboard. The 'textField' passed in is a pointer to the textField
    // widget the cursor was in at the time they touched the Return key on
    // the keyboard.
    //
    // From the Apple documentation: Asks the delegate if the text field
    // should process the pressing of the return button.
    //
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setURL(url: String) {
        avatarPhoto.setPhoto(imageURL: url)
        btnAvatar.setImage(avatarPhoto.getImage(), for: .normal)
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
