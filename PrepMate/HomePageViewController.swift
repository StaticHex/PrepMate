//
//  HomePageViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/20/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    // UI Outlets
    @IBOutlet weak var menu: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        menu.alpha = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "logoutToLogin") {
            // TODO: Destroy user object and set up login
        }
    }

    @IBAction func onMenuButtonClick(_ sender: Any) {
        if menu.alpha == 0 {
            menu.alpha = 1
        } else {
            menu.alpha = 0
        }
    }
    
    @IBAction func onMenuLogout(_ sender: Any) {
        performSegue(withIdentifier: "logoutToLogin", sender: sender)
    }
    
    @IBAction func onMenuProfile(_ sender: Any) {
        performSegue(withIdentifier: "menuToProfile", sender: sender)
    }
    
    @IBAction func onMenuSettings(_ sender: Any) {
        performSegue(withIdentifier: "menuToSetting", sender: sender)
    }
}
