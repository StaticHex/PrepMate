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

class UserProfileViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, URLProtocol, bListProtocol, bListCellProtocol {
    // ProfileProtocol Delegate
    weak var profileDelegate : ProfileProtocol?
    
    // Set up our alert controller herer
    let alert = UIAlertController(title: "",
                                  message: "",
                                  preferredStyle: .alert)
    
    // add = 0, edit = 1, view = 2, unset = -1
    var op : Int = -1
    var isPhotoSet : Bool = false
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
        self.tvBlacklist.delegate = self
        self.tvBlacklist.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        btnAvatar.layer.backgroundColor = UIColor.white.cgColor
        let clearColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.tvBlacklist.reloadData()
        // When view appears, hide and adjust UI components based on
        // whether we're adding, updating, or just viewing the user
        switch(op) {
        case 0: // add
            btnAvatar.setImage(#imageLiteral(resourceName: "2000px-Silver_-_replace_this_image_male.svg.png"), for: .normal)
            btnAvatar.isEnabled = true
            txtUserName.isEnabled = true
            txtUserName.text = ""
            txtUserName.backgroundColor = UIColor.white
            txtFName.isEnabled = true
            txtFName.text = ""
            txtFName.backgroundColor = UIColor.white
            txtLName.isEnabled = true
            txtLName.text = ""
            txtLName.backgroundColor = UIColor.white
            txtEmail.isEnabled = true
            txtEmail.text = ""
            txtEmail.backgroundColor = UIColor.white
            txtBio.isEditable = true
            txtBio.text = ""
            txtBio.isSelectable = true
            txtBio.backgroundColor = UIColor.white
            tvBlacklist.isHidden = false
            txtPrefferences.isHidden = true
            btnAddBlistItem.isHidden = false
            btnSave.isHidden = false
            btnCancel.isHidden = false
            stkPwordStack.isHidden = false
            break
        case 1: // edit
            btnAvatar.setImage(currentUser.getPhoto(), for: .normal)
            btnAvatar.isEnabled = true
            txtUserName.text = currentUser.getUname()
            txtUserName.isEnabled = false
            txtUserName.backgroundColor = UIColor.white
            txtFName.text = currentUser.getFname()
            txtFName.isEnabled = true
            txtFName.backgroundColor = UIColor.white
            txtLName.text = currentUser.getLname()
            txtLName.isEnabled = true
            txtLName.backgroundColor = UIColor.white
            txtPword.text = currentUser.getPword()
            txtVPword.text = currentUser.getPword()
            txtEmail.text = currentUser.getEmail()
            txtEmail.isEnabled = true
            txtEmail.backgroundColor = UIColor.white
            txtBio.text = currentUser.getBio()
            txtBio.isEditable = true
            txtBio.isSelectable = true
            txtBio.backgroundColor = UIColor.white
            tvBlacklist.isHidden = false
            txtPrefferences.isHidden = true
            btnAddBlistItem.isHidden = false
            btnSave.isHidden = false
            btnCancel.isHidden = false
            stkPwordStack.isHidden = false
            break
        case 2: // view
            btnAvatar.setImage(currentUser.getPhoto(), for: .normal)
            btnAvatar.isEnabled = false
            txtUserName.text = currentUser.getUname()
            txtUserName.isEnabled = false
            txtUserName.backgroundColor = clearColor
            txtFName.text = currentUser.getFname()
            txtFName.isEnabled = false
            txtFName.backgroundColor = clearColor
            txtLName.text = currentUser.getLname()
            txtLName.isEnabled = false
            txtLName.backgroundColor = clearColor
            txtEmail.text = currentUser.getEmail()
            txtEmail.isEnabled = false
            txtEmail.backgroundColor = clearColor
            txtBio.text = currentUser.getBio()
            txtBio.isEditable = false
            txtBio.backgroundColor = clearColor
            txtBio.isSelectable = false
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
    
    // Once again, not much here except for sending information to screens
    // before segues
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
            vc?.bListDelegate = self
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
            }
        }
        
    }
    
    // Pop the popovers out!
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // Functions for implementing UITableViewDelegate and UITableViewDataSource
    // Provided by Bill Bulko via class notes 2/5/2018 and 2/7/2018
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(currentUser)
        return currentUser.getPrefCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tvBlacklist.dequeueReusableCell(withIdentifier: "BlacklistCell", for: indexPath as IndexPath) as! BlacklistCell
        
        let row = indexPath.row
        let pref = currentUser.getPref(idx: row)
        let bl_key = pref.key
        let bl_value = pref.value
        cell.detail?.text = bl_key
        cell.bListDelegate = self
        cell.idx = row
        switch(bl_key) {
        case "Category":
            cell.title?.text = categoryList[bl_value]
            break
        case "Ingredient":
            cell.title?.text = ingredientList[bl_value].name
            break
        case "Type":
            cell.title?.text = foodTypeList[bl_value].name
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var row = indexPath.row
        print(row)
    }
    
    // Both of these ended up being direct segues so these two functions can be unlinked and deleted
    // TODO: Delete these when people aren't updating the storyboard
    @IBAction func onAvatarClick(_ sender: Any) {
    }
    
    @IBAction func onAddBlist(_ sender: Any) {
    }
    
    @IBAction func onSaveClick(_ sender: Any) {
        // hold these here so we can loop through them

        var isInputValid : Bool = true // check to ensure no empty fields
        var pwordMatch : Bool = true // check to ensure passwords match
        var count : Int = 0
        
        // Since we have to validate so many fields, just loop through them
        // if one of the fields is empty, draw a red border around it
        let validation = [txtUserName, txtEmail, txtPword, txtVPword]
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
        
        // If one of the required fields is blank, alert the user and then give them a chance to correct
        // the mistake or cancel
        if !isInputValid {
            alert.title = "Missing required information"
            alert.message = "You must provide a valid username, password, email, and profile picture to register\n\nNote: Failure to provide a valid email will make it unable for you to recover your password and could result in escalation of disciplinary action in the event of a violation of terms of service."
            self.present(alert, animated: true)
        // Need to make sure user can type their password at least somewhat easily
        } else if(txtPword.text! != txtVPword.text) {
            alert.title = "Passwords do not match"
            alert.message = "Please retype your password again or choose a new password"
            self.present(alert, animated: true)
            pwordMatch = false
        }
        
        // if everything above was OK, reset all border colors and perform our database operations
        if isInputValid && pwordMatch {
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
                // Try to add our user, if an error occurs, display an alert with
                // an error message
                var newRecord = UserRecord()
                newRecord.uname = txtUserName.text!
                newRecord.pword = txtPword.text!
                newRecord.photo = avatarPhoto.getPath()
                newRecord.fname = txtFName.text!
                newRecord.lname = txtLName.text!
                newRecord.email = txtEmail.text!
                newRecord.bio = txtBio.text!
                if(!currentUser.addUser(newUser: newRecord)) {
                    profileDelegate?.updateUser(newUser: currentUser)
                } else {
                    alert.title = "User Not Added"
                    alert.message = currentUser.getEMsg()
                    self.present(alert, animated: true)
                }

            } else if op == 1 {
                // Try to update our user, if an error occurs, display an alert with
                // an error message
                var newRecord = UserRecord()
                newRecord.uname = txtUserName.text!
                newRecord.pword = txtPword.text!
                newRecord.photo = avatarPhoto.getPath()
                newRecord.fname = txtFName.text!
                newRecord.lname = txtLName.text!
                newRecord.email = txtEmail.text!
                newRecord.bio = txtBio.text!
                if(!currentUser.updateUser(newUser: newRecord)) {
                    profileDelegate?.updateUser(newUser: currentUser)
                } else {
                    alert.title = "User Not Updated"
                    alert.message = currentUser.getEMsg()
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    // Needed for URLProtocol, passes information back here from our popover
    func setURL(url: String) {
        avatarPhoto.setPhoto(imageURL: url)
        btnAvatar.setImage(avatarPhoto.getImage(), for: .normal)
        if(avatarPhoto.getEMsg() != "" || avatarPhoto.getPath() == "") {
            alert.title = "Photo could not be set"
            alert.message = avatarPhoto.getEMsg()
            self.present(alert, animated: true)
        }
    }
    
    // Needed for bListProtocol. passes information back from popover
    func updateBlist(item: (bl_key: String, bl_value: Int)) {
        var pref = UserPreference()
        pref.key = item.bl_key
        pref.value = item.bl_value
        let error = currentUser.addPreference(pref: pref)
        if(error) {
            alert.title = "Preference could not be added"
            alert.message = currentUser.getEMsg()
            self.present(alert, animated: true)
        }
        tvBlacklist.reloadData()
    }
    
    func removeBListCell(idx: Int) {
        let error = currentUser.removePreference(idx: idx)
        if(error) {
            alert.title = "Preference could not be removed"
            alert.message = currentUser.getEMsg()
            self.present(alert, animated: true)
        }
        tvBlacklist.reloadData()
    }
}
