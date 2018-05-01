//
//  AddRecipeSecondPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol secondPageProtocol : class {
    func setRecipe(recipe: RecipeRecord)
}

protocol removeVitaminProtocol : class {
    func removeVitamin(cell: VitaminCustomCell)
}

class VitaminCustomCell: UITableViewCell {
    @IBOutlet weak var vitaminName: UILabel!
    @IBOutlet weak var percentage: UILabel!
    
    weak var vProtocol : removeVitaminProtocol?
    
    @IBAction func removeVit(_ sender: Any) {
        vProtocol?.removeVitamin(cell: self)
    }
    
}

class AddRecipeSecondPageViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, addVitaminProtocol, removeVitaminProtocol, URLProtocol {

    // Outlets
    @IBOutlet weak var potassiumField: UITextField!
    @IBOutlet weak var cholesterolField: UITextField!
    @IBOutlet weak var carbField: UITextField!
    @IBOutlet weak var fiberField: UITextField!
    @IBOutlet weak var fatField: UITextField!
    @IBOutlet weak var caloriesField: UITextField!
    @IBOutlet weak var sodiumField: UITextField!
    @IBOutlet weak var sugarField: UITextField!
    @IBOutlet weak var unsatField: UITextField!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var vitaminTableView: UITableView!
    
    var rPhoto = Photo()
    
    // List for maintaining display of vitamins
    var vitamins: [Vitamin] = [Vitamin]()
    
    // Recipe that will be saved if the user chooses to (will be passed from first add page controller)
    var recipeToSave: RecipeRecord = RecipeRecord()
    
    // passed recipe to edit
    var recipeToUpdate : Recipe?
    
    var addRecipeDelegate: secondPageProtocol?
    
    var fromEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vitaminTableView.delegate = self
        vitaminTableView.dataSource = self
        func back(sender: UIBarButtonItem) {
            print("Back Pressed!")
            let vc = self.navigationController?.popViewController(animated: true) as? AddRecipeFirstPageViewController
            vc?.recipeToSave = self.recipeToSave
            print("Saved Recipe")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        self.loadRecipe()
    }
    override func viewWillDisappear(_ animated: Bool) {
        // If user is returning to the first page
        if self.isMovingFromParentViewController {
            self.saveRecipeValues()
            self.addRecipeDelegate?.setRecipe(recipe: self.recipeToSave)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vitamins.count
    }
    
    func removeVitamin(cell: VitaminCustomCell) {
        let indexPath = self.vitaminTableView.indexPath(for: cell)
        vitamins.remove(at: indexPath!.row)
        self.vitaminTableView.deleteRows(at: [indexPath!], with: .fade)
    }
    
    /// Load any available recipe changes
    func loadRecipe() {
        self.caloriesField.text = "\(self.recipeToSave.calories)"
        self.fatField.text = "\(self.recipeToSave.satFat)"
        self.unsatField.text = "\(self.recipeToSave.unsatFat)"
        self.cholesterolField.text = "\(self.recipeToSave.cholesterol)"
        self.sodiumField.text = "\(self.recipeToSave.sodium)"
        self.potassiumField.text = "\(self.recipeToSave.potassium)"
        self.sugarField.text = "\(self.recipeToSave.sugar)"
        self.carbField.text = "\(self.recipeToSave.carbs)"
        self.fiberField.text = "\(self.recipeToSave.fiber)"
        print(self.recipeToSave.vitamins.count)
        if self.recipeToSave.vitamins.count > 0 {
            for vitamin in self.recipeToSave.vitamins {
                self.vitamins.append(vitamin)
            }
            self.vitaminTableView.reloadData()
        }
        if self.recipeToSave.photo != "" {
            rPhoto.setPhoto(imageURL: self.recipeToSave.photo)
            btnPhoto.setImage(rPhoto.getImage(), for: .normal)
        }
    }
    
    /// Save recipe changes before returning to the first add recipe page
    func saveRecipeValues() {
        self.recipeToSave.calories = Double(caloriesField.text!)!
        self.recipeToSave.satFat = Double(fatField.text!)!
        self.recipeToSave.unsatFat = Double(unsatField.text!)!
        self.recipeToSave.cholesterol = Double(cholesterolField.text!)!
        self.recipeToSave.sodium = Double(sodiumField.text!)!
        self.recipeToSave.potassium = Double(potassiumField.text!)!
        self.recipeToSave.sugar = Double(sugarField.text!)!
        self.recipeToSave.carbs = Double(carbField.text!)!
        self.recipeToSave.fiber = Double(fiberField.text!)!
        self.recipeToSave.photo = rPhoto.getPath()
        self.recipeToSave.vitamins = vitamins

    }
    // Displaying information for a vitamin in the Vitamin table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vitaminTableCell", for: indexPath as IndexPath) as! VitaminCustomCell
        
        let row = indexPath.row
        cell.vProtocol = self
        cell.vitaminName.text = vitaminList[vitamins[row].idx]
        cell.percentage.text = String(vitamins[row].percent) + " %"
            
        return cell
    }
    
    // Information used for passing through the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addVitaminPopover" {
            let vc = segue.destination as? AddVitaminPopoverViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.addVitaminDelegate = self
            }
        }
        if segue.identifier == "AddPhotoPopover" {
            let vc = segue.destination as? AddURLViewController
            vc?.isModalInPopover = true
            if(rPhoto.getPath() != "") {
                vc?.prefix = getRecipePrefix(mode: "edit")
            } else {
                vc?.prefix = getRecipePrefix(mode: "add")
            }
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.urlDelegate = self
            }
        }
    }
    
    // Function to add a vitamin for display on the Vitamin table view
    func addVitamin(vitamin: Vitamin) {
        vitamins.append(vitamin)
        self.vitaminTableView.beginUpdates()
        self.vitaminTableView.insertRows(at: [IndexPath.init(row: vitamins.count - 1, section: 0)], with: .automatic)
        self.vitaminTableView.endUpdates()
    }
    
    // Receiving information about the recipe being created from the first page.
    func setRecipe(recipe: RecipeRecord) {
        self.recipeToSave = recipe
        print(self.recipeToSave.name)
    }
    
    // Save recipe.
    @IBAction func saveRecipe(_ sender: Any) {
        self.checkRecipe()
        print(self.recipeToSave)
        let recipe = Recipe()
        let success : Bool?
        if fromEdit {
            success = recipeToUpdate!.updateRecipe(newRecipe: self.recipeToSave)
            print("\n\n"+recipeToUpdate!.getEMsg()+"\n\n")
        }
        else {
            success = recipe.addRecipe(newRecipe: self.recipeToSave)
        }
        if success! {
            self.databaseAlert(str: "Database Error")
        }
        else {
            self.popViews()
            return
        }
        
    }
    /// Verifies that all fields have been filled
    func checkRecipe(){
        self.saveRecipeValues()
        if(self.recipeToSave.name == "") {
            self.recipeAlert(str: "Name")
            return
        }
        if(self.recipeToSave.prepTime == "00:00:00") {
            self.recipeAlert(str: "Prep Time")
            return
        }
        if(self.recipeToSave.cookTime == "00:00:00") {
            self.recipeAlert(str: "Cook Time")
            return
        }
        if(self.recipeToSave.calories == -1) {
            self.recipeAlert(str: "Calories")
            return
        }
        if(self.recipeToSave.satFat == -1) {
            self.recipeAlert(str: "Saturated Fat")
            return
        }
        if(self.recipeToSave.unsatFat == -1) {
            self.recipeAlert(str: "Unsatuared Fat")
            return
        }
        if(self.recipeToSave.cholesterol == -1) {
            self.recipeAlert(str: "Cholesterol")
            return
        }
        if(self.recipeToSave.sodium == -1) {
            self.recipeAlert(str: "Sodium")
            return
        }
        if(self.recipeToSave.potassium == -1) {
            self.recipeAlert(str: "Potassium")
            return
        }
        if(self.recipeToSave.carbs == -1) {
            self.recipeAlert(str: "Carbohydrate")
            return
        }
        if(self.recipeToSave.fiber == -1) {
            self.recipeAlert(str: "Fiber")
            return
        }
        if(self.recipeToSave.sugar == -1) {
            self.recipeAlert(str: "Sugar")
            return
        }
        if(self.recipeToSave.ingredients.count == 0) {
            self.recipeAlert(str: "Ingredients")
            return
        }
        if(self.recipeToSave.directions.count == 0) {
            self.recipeAlert(str: "Directions")
            return
        }
        if(self.recipeToSave.vitamins.count == 0) {
            self.recipeAlert(str: "Vitamins")
            return
        }
    }
    
    /// Helper function to alert recipe errors
    func recipeAlert(str:String) {
        let alert = UIAlertController(title: "Add Recipe Error", message: "\(str) field cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func databaseAlert(str:String) {
        let alert = UIAlertController(title: "Add Recipe Error", message: "\(str)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setURL(url: String) {
        rPhoto.setPhoto(imageURL: url)
        btnPhoto.setImage(rPhoto.getImage(), for: .normal)
    }
    
    // User is sent back to the home page
    @IBAction func cancelRecipe(_ sender: Any) {
        
        // Remove saved data from Contains and Dietary popovers
        for c in 0...(containsVector.count-1) {
            containsVector[c] = false
        }
        for d in 0...(dietaryVector.count-1) {
            dietaryVector[d] = false
        }
        
        self.popViews()
        
    }
    
    func popViews()
    {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomePageViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func getRecipePrefix(mode:String) -> String {
        let lMode = mode.lowercased()
        var prefix = ""
        
        if (lMode == "add") {
            var lastRID = ""
            
            // create a variable to return whether we errored out or not
            var vError : Bool = false
            
            // path to our backend script
            let URL_VERIFY = "http://www.teragentech.net/prepmate/GetMaxRecipe"
            
            // variable which will spin until verification is finished
            var finished : Bool = false
            
            // create our URL object
            let url = URL(string: URL_VERIFY)
            
            // create the request and set the type to POST, otherwise we get authorization error
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            let params = "" // not sure if we need to pass this or not so just passing empty
            
            request.httpBody = params.data(using: String.Encoding.utf8)
            
            // Create a task and send our request to our REST API
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                // if we error out, return the error message
                if(error != nil) {
                    //self.eMsg = error!.localizedDescription
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
                        //self.eMsg = parseJSON["msg"] as! String
                        vError = (parseJSON["error"] as! Bool)
                        if(!vError) {
                            if let rid = parseJSON["id"] as? String {
                                lastRID = String(Int(rid)!+1)
                            } else {
                                lastRID = ""
                                vError = true
                            }
                        }
                    }
                } catch {
                    //self.eMsg = error.localizedDescription
                    vError = true
                }
                finished = true
            }
            // execute our task and then return the results
            task.resume()
            while(!finished) {}
            
            // Wipe recipe entry
            if(!vError) {
                prefix = currentUser.getUname().lowercased()+lastRID
            }
        } else {
            let uname = currentUser.getUname()
            let id = "\(recipeToUpdate?.getId())"
            prefix = uname+id
        }
        return prefix
    }
}
