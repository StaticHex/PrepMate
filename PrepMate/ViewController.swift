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
        self.navigationController?.isNavigationBarHidden = true
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
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var count = 1
        var running = false
        var con = cTest()
        let queue = DispatchQueue.global()
        
        // Set up our alert controller herer
        let alert = UIAlertController(title: "fake title", message: "Do you want to try to connect again?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:  { action in
            running = false
            count = 0
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            exit(0)
        }))

        // Start spinning
        queue.async {
            // don't go past this screen until we verify connection
            while(con.error) {
                // keep trying to connect every 3 seconds up to 5x
                if(!running && count < 5) {
                    running = true;
                    queue.asyncAfter(deadline: .now() + 3.0) {
                        con = self.cTest()
                        running = false
                        count += 1
                    }
                // After 5x, display an alert to the user
                } else if (count == 5) {
                    DispatchQueue.main.sync {
                        // set title and display alert
                        alert.title = "An unexpected error occured: \(con.msg)"
                        self.present(alert, animated: true)
                    }
                    count += 1
                }
            }
            // After we verify connection go to the login screen
            DispatchQueue.main.sync {
                self.performSegue(withIdentifier: self.segueID, sender: nil)
            }
        }
    }
    
    // Connection test function
    // @description
    // - Connects to the specified PHP script via POST and
    //   verifies connection to the prepmate database
    // @return
    // - Returns a tuple containing whether there was an
    //   error connecting to the database as well as an
    //   error message in the event of an error. A successful
    //   connection returns an empty string for the message
    func cTest() -> (error: Bool, msg: String) {
        var ret = (error: true, msg: "")
        var finished = false
        // path to the connection test script
        let path = "http://www.teragentech.net/prepmate/CTest.php"
        
        // create our URL object
        let url = URL(string: path)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                ret.msg = error!.localizedDescription
                finished = true
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    ret.error = parseJSON["error"] as! Bool
                    ret.msg = parseJSON["message"] as! String
                }
            } catch {
                ret.msg = error.localizedDescription
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        return ret
    }
}
