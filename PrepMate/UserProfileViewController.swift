//
//  UserProfileViewController.swift
//  PrepMate
//
//  Created by Joseph Bourque on 3/17/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    // UI Component Outlets
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRetypePassword: UITextField!
    @IBOutlet weak var tblViewBlist: UITableView!
    @IBOutlet weak var btnAddBlistItem: UIButton!
    @IBOutlet weak var btnRmvBlistItem: UIButton!
    @IBOutlet weak var txtVBio: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addBlistItem(_ sender: Any) {
    }
    
    @IBAction func rmvBlistItem(_ sender: Any) {
    }
    
    @IBAction func saveUser(_ sender: Any) {
    }
    
    @IBAction func cancelChanges(_ sender: Any) {
    }
}
