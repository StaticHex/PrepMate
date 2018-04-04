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
class UserProfileViewController: UIViewController {
    // ProfileProtocol Delegate
    weak var profileDelegate : ProfileProtocol?
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
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
        for v in validation {
            if v?.text! == "" {
                isInputValid = false
                v?.layer.borderColor = UIColor.red.cgColor
                v?.layer.borderWidth = 1.0
            }
        }
        if !isInputValid {
            // show alert
        }
        if(txtPword.text! != txtVPword.text) {
            // show alert
            pwordMatch = false
        }
        if(avatarPhoto.getPath()=="") {
            isPhotoSet = false
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
            
            if op == 0 {
                currentUser.addUser(newUser: (uname: txtUserName.text!, pword: txtPword.text!, photo: avatarPhoto, fname: txtFName.text!, lname: txtLName.text!, email: txtEmail.text!, bio: txtBio.text!))
            } else if op == 1 {
                currentUser.updateUser(newUser: (uname: txtUserName.text!, pword: txtPword.text!, photo: avatarPhoto, fname: txtFName.text!, lname: txtLName.text!, email: txtEmail.text!, bio: txtBio.text!))
            }
            profileDelegate?.updateUser(newUser: currentUser)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
    }
}
