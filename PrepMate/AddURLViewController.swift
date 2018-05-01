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

class AddURLViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    // UI Component outlets
    @IBOutlet weak var btnPhoto: UIButton!
    
    // delegate to pass built URL back to main view controller
    weak var urlDelegate : URLProtocol?
    
    // this is sent from the calling view controller, will either pass in userName or a recipeId
    var prefix = ""
    
    // holds the local file name for our image, needed to test whether image is a .jpg, .jpeg, or .png
    var localPath = ""
    
    // holds the file extension for our image
    var ext = ""
    
    // a variable to hold the URL for our uploaded image
    var builtURL = ""
    
    //image picker to grab photos from our gallery
    let imagePicker = UIImagePickerController()
    
    // Set up our alert controller herer
    let alert = UIAlertController(title: "Photo was not uploaded",
                                  message: "message",
                                  preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
        // fix image in the center of our button
        btnPhoto.contentMode = .center
        btnPhoto.imageView?.contentMode = .scaleAspectFit
        
        //set up image picker
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .popover
        imagePicker.popoverPresentationController?.delegate = self
        imagePicker.popoverPresentationController?.sourceView = view
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ext = ""
        builtURL = ""
        localPath = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Image picker functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let newImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            if let path = info[UIImagePickerControllerImageURL] as? URL {
                btnPhoto.setImage(newImage, for: .normal)
                localPath = path.lastPathComponent
                let name = localPath.split(separator: ".")
                ext = String(name.last!)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func onPickPhoto(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onSaveClick(_ sender: Any) {
        if (!uploadImage(prefix: prefix)) {
            builtURL = "http://www.teragentech.net/prepmate/files/\(prefix)/photo.\(ext)"
            urlDelegate?.setURL(url: builtURL)
            self.dismiss(animated: true, completion: nil)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // File Upload Functions
    func uploadImage(prefix : String) -> Bool {
        print(localPath + " " + prefix + " " + ext)
        // bool to ensure upload finishes before moving on
        var finished = false
        var vError = false
        
        let myURL = URL(string: "http://www.teragentech.net/prepmate/UploadImage.php")
        
        var request = URLRequest(url: myURL!)
        
        request.httpMethod = "POST"
        
        let param = [
            "prefix" : "\(prefix)",
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var imageData : Data?

        if(ext=="jpeg" || ext=="jpg") {
            imageData = UIImageJPEGRepresentation(btnPhoto.image(for: .normal)!, 1)
        } else if(ext=="png") {
            imageData = UIImagePNGRepresentation(btnPhoto.image(for: .normal)!)
        } else {
            self.alert.message = "Image in wrong format, must be .jpeg, .jpg or .png"
            return true
        }
        
        if(imageData == nil) {
            self.alert.message = "Corrupted or missing image data"
            return true
        }
        
        request.httpBody = createBodyWithParameters(parameters: param, fileName: "photo", imageDataKey: imageData!, boundary: boundary, ext: ext)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                self.alert.message = error!.localizedDescription
                finished = true
                vError = true
                return
            }
            
            // If there was no error, parse the response
            do {
                // convert response to a dictionary
                let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                // Get the error status and the error message from the database
                if let parseJSON = JSONResponse {
                    if let msg = parseJSON["msg"] as? String {
                        self.alert.message = msg
                    }
                    vError = (parseJSON["error"] as! Bool)
                }
            } catch {
                self.alert.message = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        
        while(!finished) {}
        
        return vError
    }
    
    func createBodyWithParameters(parameters: [String: String]?, fileName : String, imageDataKey : Data, boundary : String, ext : String) -> Data {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "\(fileName).\(ext)"
        let mimetype = "image/\(ext)"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return (body as Data)
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
