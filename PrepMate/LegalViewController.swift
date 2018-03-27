//
//  LegalViewController.swift
//  PrepMate
//
//  Created by Joseph Bourque on 3/19/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class LegalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

}
