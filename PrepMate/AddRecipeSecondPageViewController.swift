//
//  AddRecipeSecondPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class AddRecipeSecondPageViewController: UIViewController {

    @IBOutlet weak var potassiumField: UITextField!
    @IBOutlet weak var cholesterolField: UITextField!
    @IBOutlet weak var carbField: UITextField!
    @IBOutlet weak var fiberField: UITextField!
    @IBOutlet weak var fatField: UITextField!
    @IBOutlet weak var caloriesField: UITextField!
    @IBOutlet weak var sodiumField: UITextField!
    @IBOutlet weak var sugarField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }


}
