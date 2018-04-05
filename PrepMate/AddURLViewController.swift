//
//  AddURLViewController.swift
//  PrepMate
//
//  Created by Joseph Bourque on 4/4/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol URLProtocol : class {
    func setURL(url : String)
}

class AddURLViewController: UIViewController {

    weak var urlDelegate : URLProtocol?
    
    // Set up our alert controller herer
    let alert = UIAlertController(title: "Pick a valid image URL",
                                  message: "Image URL must end in either .jpg, .jpeg, .png, or .gif",
                                  preferredStyle: .alert)
    
    // UI Component outlets
    @IBOutlet weak var txtURL: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This method is called when the user touches the Return key on the
    // keyboard. The 'textField' passed in is a pointer to the textField
    // widget the cursor was in at the time they touched the Return key on
    // the keyboard.
    //
    // From the Apple documentation: Asks the delegate if the text field
    // should process the pressing of the return button.
    //
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func onSaveClick(_ sender: Any) {
        var isValidImage : Bool = false

        // check to see if image ends in a valid image format
        let suffix = substring(tok: txtURL.text!, begin: txtURL.text!.count-4, end: txtURL.text!.count)
        let accepted = [".jpg", ".jpeg", ".gif", ".png"]
        for a in accepted {
            if(suffix == a) {
                isValidImage = true
                break
            }
        }
        
        // if image was not valid, display alert, otherwise pass image back to sender
        if !isValidImage {
            self.present(alert, animated: true)
        } else {
            urlDelegate?.setURL(url: txtURL.text!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // substring function because apple depreciated theirs
    func substring(tok: String, begin : Int, end : Int) -> String {
        if begin < 0 || end < 0 {
            return ""
        }
        if begin >= end {
            return ""
        }
        
        var count : Int = 0
        let tokArray = Array(tok)
        var retStr : String = ""
        for c in tokArray {
            if count >= begin && count < end {
                retStr += String(c)
            }
            if count >= end {
                break
            }
            count += 1
        }
        
        return retStr
    }
}
