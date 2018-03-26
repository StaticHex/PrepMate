//
//  ViewController.swift
//  PrepMate
//  Team: 2
//  Members: Joseph Bourque, Yen Chen Wee, Pablo Velasco
//  Course: CS 371L
//
//  Created by Joseph Bourque on 3/16/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // UI Component outlets
    @IBOutlet weak var loadIcon: UIImageView!
    @IBOutlet weak var statusMsg: UILabel!
    
    let segueID = "LoginSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadIcon.animationImages = [#imageLiteral(resourceName: "frame_00_delay-0.04s.png"), #imageLiteral(resourceName: "frame_01_delay-0.04s.png"), #imageLiteral(resourceName: "frame_02_delay-0.04s.png"), #imageLiteral(resourceName: "frame_03_delay-0.04s.png"), #imageLiteral(resourceName: "frame_04_delay-0.04s.png"), #imageLiteral(resourceName: "frame_05_delay-0.04s.png"), #imageLiteral(resourceName: "frame_06_delay-0.04s.png"), #imageLiteral(resourceName: "frame_07_delay-0.04s.png"), #imageLiteral(resourceName: "frame_08_delay-0.04s.png"), #imageLiteral(resourceName: "frame_09_delay-0.04s.png"),
                                    #imageLiteral(resourceName: "frame_10_delay-0.04s.png"), #imageLiteral(resourceName: "frame_11_delay-0.04s.png"), #imageLiteral(resourceName: "frame_12_delay-0.04s.png"), #imageLiteral(resourceName: "frame_13_delay-0.04s.png"), #imageLiteral(resourceName: "frame_14_delay-0.04s.png"), #imageLiteral(resourceName: "frame_15_delay-0.04s.png"), #imageLiteral(resourceName: "frame_16_delay-0.04s.png"), #imageLiteral(resourceName: "frame_17_delay-0.04s.png"), #imageLiteral(resourceName: "frame_18_delay-0.04s.png"), #imageLiteral(resourceName: "frame_19_delay-0.04s.png"),
                                    #imageLiteral(resourceName: "frame_20_delay-0.04s.png"), #imageLiteral(resourceName: "frame_21_delay-0.04s.png"), #imageLiteral(resourceName: "frame_22_delay-0.04s.png"), #imageLiteral(resourceName: "frame_23_delay-0.04s.png")]
        loadIcon.animationDuration = 1.0
        loadIcon.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Method used to pass information to the destination view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == segueID) {
            let _ = segue.destination as? LoginViewController
            print("WE HIT THIS")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: segueID, sender: nil)
    }
}
