//
//  LoginViewController.swift
//  PrepMate
//  Team: 2
//  Members: Joseph Bourque, Yen Chen Wee, Pablo Velasco
//  Course: CS 371L
//
//  Created by Joseph Bourque on 3/17/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIPopoverPresentationControllerDelegate, ProfileProtocol {
    
    // UIComponent Outlets
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var swtRememberMe: UISwitch!
    
    var segueId = "" // Used for switching between segues
    
    var appUser = User() // holds our current user, this is passed from screen to screen
    
    // Set up our alert controller herer
    let alert = UIAlertController(title: "Sorry, we couldn't log you in", message: "", preferredStyle: .alert)


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // add an OK button to our alert
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Not too much to see here, mainly just sending information to various
    // views when needed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "loginToHomeSegue") {
            let dest = segue.destination as? HomePageViewController
            dest?.appUser.copy(oldUser: appUser)
            appUser.clear()
        } else if(segue.identifier == "loginToUserProfile") {
            let dest = segue.destination as? UserProfileViewController
            dest?.profileDelegate = self
            dest?.op = 0 // Tell profile page it's doing an add operation
        } else if(segue.identifier == "resetPwordPopover") {
            let vc = segue.destination as? ResetPwordViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
            }
        }
    }
    
    // needed to make popover pop!
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true // hide the navigation bar
        txtPassword.text = ""
        txtUserName.text = ""
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
    
    func updateUser(newUser: User) {
        self.navigationController?.popViewController(animated: true)
        appUser.copy(oldUser: newUser)
        performSegue(withIdentifier: "loginToHomeSegue", sender: nil)
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func btnLogInClick(_ sender: Any) {
        segueId = "loginToHomeSegue"
        
        // Run our verify function, to make sure user has valid credentials
        if(self.appUser.verify(uname: txtUserName.text!, pword: txtPassword.text!)) {
            performSegue(withIdentifier: segueId, sender: sender)
        } else {
            alert.message = appUser.getEMsg()
            self.present(alert, animated: true)
        }
        
        // Comment out block above and uncomment following line to skip login screen
        // for faster debug
        // WARNING!: Commenting out block above leaves you with a <<null>> user so
        // some functions may not work if you do this
        //performSegue(withIdentifier: segueId, sender: sender)
    }
    
    @IBAction func btnSignUpClick(_ sender: Any) {
        segueId = "loginToUserProfile"
    }
    
    // Segue attached directly, so I don't think we need this anymore.
    // TODO: Delete this when people aren't working on the storyboard
    @IBAction func btnForgotPasswordClick(_ sender: Any) {
    }
}
