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

class LoginViewController: UIViewController {
    
    // UIComponent Outlets
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var swtRememberMe: UISwitch!
    
    var segueId = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "loginToHomeSegue") {
            let _ = segue.destination as? HomePageViewController
            // TODO: pass user data to home screen
        } else if(segue.identifier == "loginToUserProfile") {
            let _ = segue.destination as? UserProfileViewController
            // TODO: pass "add" operation to user profile screen
        }
    }

    @IBAction func btnLogInClick(_ sender: Any) {
        segueId = "loginToHomeSegue"
        performSegue(withIdentifier: segueId, sender: sender)
    }
    
    @IBAction func btnSignUpClick(_ sender: Any) {
        segueId = "loginToUserProfile"
        performSegue(withIdentifier: segueId, sender: sender)
    }
    
    @IBAction func btnForgotPasswordClick(_ sender: Any) {
    }
    
}
