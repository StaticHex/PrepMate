//
//  Ingredient.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation
class Ingredient {
    private var id : Int
    private var name : String
    private var unit : Int
    private var customLabel : String
    init(id:Int, name: String, unit: Int, customLabel:String) {
        self.id = id
        self.name = name
        self.unit = unit
        self.customLabel = customLabel
    }
    
    func getId() -> Int { return self.id}
    func getName() -> String { return self.name}
    //TODO: change this to correctly reflect type of units
    func getUnit() -> Int { return self.unit}
    func getCustomLabel() -> String { return self.customLabel}
    
    public func AddIngredient(rid: Int, iid:Int, amount:Float)-> (Bool, String) {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AddRecipeIngredient.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "rid=\(rid)&iid=\(iid)&amount=\(amount)"
        var eMsg = ""
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                eMsg = error!.localizedDescription
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
                    eMsg = parseJSON["msg"] as! String
                    vError = (parseJSON["error"] as! Bool)
                }
            } catch {
                eMsg = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        return (vError, eMsg)
    }
}
