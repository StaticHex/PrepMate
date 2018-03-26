//
//  CustomUnitPopoverViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/20/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class CustomUnitPopoverViewController: UIViewController {
    
    var dontShowAgain: Bool = false
    
    @IBOutlet weak var dontShowAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dontShowAgain(_ sender: Any) {
        dontShowAgain = true
        dontShowAgainButton.setTitle("■", for: .normal)
    }
    
    @IBAction func exit(_ sender: Any) {
         dismiss(animated:true, completion: nil)
        performSegue(withIdentifier: "customUnitsSegue", sender: AnyClass.self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
