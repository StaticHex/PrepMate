//
//  ResetPwordViewController.swift
//  PrepMate
//
//  Created by Joseph Bourque on 4/1/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class ResetPwordViewController: UIViewController {

    @IBOutlet weak var txtUname: UITextField!
    
    var vError : Bool = true
    // Set up our alert controller herer
    let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
            if(!self.vError) {
                self.dismiss(animated: true, completion: nil)
            }
        }))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onResetClick(_ sender: Any) {
        if (txtUname.text! !=  "") {
            // path to our backend script
            let URL_VERIFY = "http://www.teragentech.net/prepmate/ResetPword.php"
            
            // variable which will spin until verification is finished
            var finished : Bool = false
            
            // create our URL object
            let url = URL(string: URL_VERIFY)
            
            // create the request and set the type to POST, otherwise we get authorization error
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            let params = "uname="+txtUname.text!
            
            request.httpBody = params.data(using: String.Encoding.utf8)
            
            // Create a task and send our request to our REST API
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                // if we error out, return the error message
                if(error != nil) {
                    self.alert.message = error!.localizedDescription
                    finished = true
                    self.vError = true
                    return
                }
                
                // If there was no error, parse the response
                do {
                    // convert response to a dictionary
                    let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    // Get the error status and the error message from the database
                    if let parseJSON = JSONResponse {
                        self.alert.message = parseJSON["msg"] as? String
                        self.vError = (parseJSON["error"] as! Bool)
                    }
                } catch {
                    self.alert.message = error.localizedDescription
                    self.vError = true
                }
                finished = true
            }
            // execute our task and then return the results
            task.resume()
            while(!finished) {}
            if(vError) {
                alert.title = "Reset Unsuccessful!"
            } else {
                alert.title = "Reset Successful!"
                alert.message = "Your new password has been sent to the email linked to your account."
            }
            self.present(alert, animated: true)
        } else {
            alert.title = "Reset Unsuccessful!"
            alert.message = "You must enter a valid username to perform this action."
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
