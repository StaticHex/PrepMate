//
//  UserProfileViewController.swift
//  PrepMate
//
//  Created by Joseph Bourque on 3/17/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    // add = 0, edit = 1, view = 2, unset = -1
    var op : Int = -1
    var currentUser : User = User()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        switch(op) {
        case 0: // add
            break
        case 1: // edit
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
            break
        case 2: // view
            txtUserName.text = currentUser.getUname()
            txtUserName.isEnabled = false
            txtFName.text = currentUser.getFname()
            txtFName.isEnabled = false
            txtLName.text = currentUser.getLname()
            txtEmail.text = currentUser.getEmail()
            txtBio.text = currentUser.getBio()
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
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
    }
}
