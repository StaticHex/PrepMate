//
//  NewListItemViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/20/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class NewListItemViewController: UIViewController {

    @IBOutlet weak var itemNameInput: UITextField!
    @IBOutlet weak var amountInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "customUnitWarningSegue" {
            let vc = segue.destination as? CustomUnitPopoverViewController
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func selectUnits(_ sender: Any) {
        // if value of don't show is true, go straight to units
        // else don't show
        // Protocol method here
        self.performSegue(withIdentifier: "customUnitWarningSegue", sender: AnyClass.self)
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        // TODO: Save item
        dismiss(animated: true, completion: nil)
    }
    
}
