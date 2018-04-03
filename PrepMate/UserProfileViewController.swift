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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
