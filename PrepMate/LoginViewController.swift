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

class LoginViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // UIComponent Outlets
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var swtRememberMe: UISwitch!
    
    var segueId = ""
    
    var appUser = User()
    
    // Set up our alert controller herer
    let alert = UIAlertController(title: "Sorry, we couldn't log you in", message: "", preferredStyle: .alert)


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "loginToHomeSegue") {
            let dest = segue.destination as? HomePageViewController
            dest?.appUser.copy(oldUser: appUser)
            appUser.clear()
            // TODO: pass user data to home screen
        } else if(segue.identifier == "loginToUserProfile") {
            let _ = segue.destination as? UserProfileViewController
            // TODO: pass "add" operation to user profile screen
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
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    // Called when the user touches on the main view (outside the UITextField).
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func btnLogInClick(_ sender: Any) {
        segueId = "loginToHomeSegue"
        /*
        if(self.appUser.verify(uname: txtUserName.text!, pword: txtPassword.text!)) {
            performSegue(withIdentifier: segueId, sender: sender)
        } else {
            alert.message = appUser.getEMsg()
            self.present(alert, animated: true)
        }
        */
        performSegue(withIdentifier: segueId, sender: sender)
    }
    
    @IBAction func btnSignUpClick(_ sender: Any) {
        segueId = "loginToUserProfile"
        performSegue(withIdentifier: segueId, sender: sender)
    }
    
    @IBAction func btnForgotPasswordClick(_ sender: Any) {
    }
}
