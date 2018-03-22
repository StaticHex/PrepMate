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
    @IBOutlet weak var txtPassword: UIStackView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var swtRemember: UISwitch!
    @IBOutlet weak var btnForgotPassword: UIButton!
    

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

    @IBAction func login(_ sender: Any) {
    }
    
    @IBAction func signUp(_ sender: Any) {
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
    }
}
