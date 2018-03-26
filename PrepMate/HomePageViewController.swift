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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onMenuButtonClick(_ sender: Any) {
        if menu.alpha == 0 {
            menu.alpha = 1
        } else {
            menu.alpha = 0
        }
    }
}
