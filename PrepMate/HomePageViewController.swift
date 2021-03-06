//
//  HomePageViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/20/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol settingsProtocol: class {
    func changeSidebarColor(color: UIColor)
}

class PopularCustomViewCell: UICollectionViewCell {
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
}

class RecommendedCustomViewCell: UICollectionViewCell {
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
}

class HomeCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var cuisineImage: UIImageView!
}

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, settingsProtocol, ProfileProtocol, SearchFilterProtocol {
    
    // UI Outlets
    @IBOutlet weak var menu: UIView!
    @IBOutlet weak var lblRecipeOptions: UILabel!
    @IBOutlet weak var btnAddNewRecipe: UIButton!
    @IBOutlet weak var btnRemoveRecipe: UIButton!
    @IBOutlet weak var lblDataManagement: UILabel!
    @IBOutlet weak var btnMyRecipes: UIButton!
    @IBOutlet weak var btnMyFavorites: UIButton!
    @IBOutlet weak var btnMyPantry: UIButton!
    @IBOutlet weak var btnMyShoppingList: UIButton!
    @IBOutlet weak var btnMyMeals: UIButton!
    @IBOutlet weak var lblUserManagement: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblLegal: UILabel!
    @IBOutlet weak var btnCredits: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var recommendedCollectionView: UICollectionView!
    @IBOutlet weak var tvSearchAutofill: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var popularLabel: UILabel!
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    var thisRow = 0
    var recipeList = [Recipe]()
    var recommendedList = [Recipe]()
    var searchFilter = ""
    var searchString = ""
    
    var whichRecipeClick = 0
    
    // This is a special recipe collection for passing between screens
    // used when moving to recipe box or search results
    var passedRecipes = [Recipe]()
    var selectedRecipe = Recipe()
    
    // Collection for the recipe autofill
    var autofillRecipes = [(id : Int, name: String, category: String)]()
    var eMsg = "" // error message for autofill function
    
    // variables for the loading alert
    let loadingAlert = UIAlertController(title: "Please wait", message: "fetching recipes...\n\n\n", preferredStyle: .alert)
    var loadIcon = UIImageView(frame: CGRect(x: 105, y: 67, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.alpha = 0
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        recommendedCollectionView.dataSource = self
        recommendedCollectionView.delegate = self
        tvSearchAutofill.delegate = self
        tvSearchAutofill.dataSource = self
        popularCollectionView.tag = 1
        recommendedCollectionView.tag = 2
        txtSearch.addTarget(self, action: #selector(nameDidChange(_:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
        loadIcon.animationImages = [#imageLiteral(resourceName: "frame_00_delay-0.04s.png"), #imageLiteral(resourceName: "frame_01_delay-0.04s.png"), #imageLiteral(resourceName: "frame_02_delay-0.04s.png"), #imageLiteral(resourceName: "frame_03_delay-0.04s.png"), #imageLiteral(resourceName: "frame_04_delay-0.04s.png"), #imageLiteral(resourceName: "frame_05_delay-0.04s.png"), #imageLiteral(resourceName: "frame_06_delay-0.04s.png"), #imageLiteral(resourceName: "frame_07_delay-0.04s.png"), #imageLiteral(resourceName: "frame_08_delay-0.04s.png"), #imageLiteral(resourceName: "frame_09_delay-0.04s.png"),
                                    #imageLiteral(resourceName: "frame_10_delay-0.04s.png"), #imageLiteral(resourceName: "frame_11_delay-0.04s.png"), #imageLiteral(resourceName: "frame_12_delay-0.04s.png"), #imageLiteral(resourceName: "frame_13_delay-0.04s.png"), #imageLiteral(resourceName: "frame_14_delay-0.04s.png"), #imageLiteral(resourceName: "frame_15_delay-0.04s.png"), #imageLiteral(resourceName: "frame_16_delay-0.04s.png"), #imageLiteral(resourceName: "frame_17_delay-0.04s.png"), #imageLiteral(resourceName: "frame_18_delay-0.04s.png"), #imageLiteral(resourceName: "frame_19_delay-0.04s.png"),
                                    #imageLiteral(resourceName: "frame_20_delay-0.04s.png"), #imageLiteral(resourceName: "frame_21_delay-0.04s.png"), #imageLiteral(resourceName: "frame_22_delay-0.04s.png"), #imageLiteral(resourceName: "frame_23_delay-0.04s.png")]
        loadingAlert.view.addSubview(loadIcon)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoryTableView.reloadData()
        recommendedCollectionView.reloadData()
        navigationController?.isNavigationBarHidden = true
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "titleBarColor") != nil {
            let decoded  = defaults.object(forKey: "titleBarColor") as! Data
            let decodedColor = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UIColor
            self.menu.backgroundColor = decodedColor
            self.popularLabel.backgroundColor = decodedColor.withAlphaComponent(0.2)
            self.recommendedLabel.backgroundColor = decodedColor.withAlphaComponent(0.2)
            self.cuisineLabel.backgroundColor = decodedColor.withAlphaComponent(0.2)
        }

        if defaults.object(forKey: "navBarTextColor") != nil {
            let decoded  = defaults.object(forKey: "navBarTextColor") as! Data
            let decodedColor = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UIColor
            
            // TODO ADD OUTLETS HERE!!!!
            self.cuisineLabel.textColor = decodedColor
            self.recommendedLabel.textColor = decodedColor
            self.popularLabel.textColor = decodedColor
            lblRecipeOptions.textColor = decodedColor
            btnAddNewRecipe.setTitleColor(decodedColor, for: .normal)
            btnRemoveRecipe.setTitleColor(decodedColor, for: .normal)
            lblDataManagement.textColor = decodedColor
            btnMyRecipes.setTitleColor(decodedColor, for: .normal)
            btnMyFavorites.setTitleColor(decodedColor, for: .normal)
            btnMyPantry.setTitleColor(decodedColor, for: .normal)
            btnMyShoppingList.setTitleColor(decodedColor, for: .normal)
            btnMyMeals.setTitleColor(decodedColor, for: .normal)
            lblUserManagement.textColor = decodedColor
            btnProfile.setTitleColor(decodedColor, for: .normal)
            btnSettings.setTitleColor(decodedColor, for: .normal)
            btnLogout.setTitleColor(decodedColor, for: .normal)
            lblLegal.textColor = decodedColor
            btnTerms.setTitleColor(decodedColor, for: .normal)
            btnCredits.setTitleColor(decodedColor, for: .normal)
        }

        if !firstRun {
            self.loadIcon.startAnimating()
            DispatchQueue.main.async {
                self.present(self.loadingAlert, animated: true, completion: {
                    print(currentUser.preferenceString())
                    self.recipeList = getRecipes(query: "id>=1\(currentUser.preferenceString()) ORDER BY rating DESC LIMIT 10")
                    self.recommendedList = getRecipes(query: "uid!=\(currentUser.getId())\(currentUser.preferenceString())")
                    self.loadingAlert.dismiss(animated: true, completion: {
                        self.loadIcon.stopAnimating()
                    })
                    self.popularCollectionView.reloadData()
                    self.recommendedCollectionView.reloadData()
                })
            }
            firstRun = true
        }
        
        txtSearch.text = ""
        searchString = ""
        searchFilter = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tvSearchAutofill.isHidden = true
        textField.resignFirstResponder()
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.popularCollectionView {
            return self.recipeList.count
        } else {
            return self.recommendedList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topRecipesCell", for: indexPath as IndexPath) as! PopularCustomViewCell
            
            let row = indexPath.row
            
            cell.foodTitle.text = self.recipeList[row].getName().capitalized
            cell.foodImage.image = self.recipeList[row].getPhoto()
            cell.foodImage.contentMode = .scaleAspectFill

            return cell
        }
        else {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendedRecipesCell", for: indexPath as IndexPath) as! RecommendedCustomViewCell
            
            let row = indexPath.row
            
            cell.foodTitle.text = self.recommendedList[row].getName().capitalized
            cell.foodImage.image = self.recommendedList[row].getPhoto()
            cell.foodImage.contentMode = .scaleAspectFill
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "logoutToLogin") {
            currentUser.clear()
        }
        if segue.identifier == "homeToSettings" {
            let vc = segue.destination as? SettingsViewController
            vc?.sDelegate = self
        }
        if segue.identifier == "homeToProfile" {
            let vc = segue.destination as? UserProfileViewController
            vc?.profileDelegate = self
            vc?.op = 1
            vc?.avatarPhoto.setPhoto(imageURL: currentUser.getPhotoURL())
            vc?.user = currentUser
        }
        if segue.identifier == "homeToCuisineSegue" {
            let vc = segue.destination as? HistoryFavoriteSearchResultsViewController
            vc?.row = self.thisRow
            vc?.recipeList = getRecipes(query: "category=\(self.thisRow)")
            
        }
        if segue.identifier == "homeToRecipeOverview" {
            let vc = segue.destination as? RecipePageViewController
            vc?.recipe = selectedRecipe
        }
        if segue.identifier == "popularToRecipeSegue" {
            let vc = segue.destination as? RecipePageViewController
            let cell = sender as! PopularCustomViewCell
            let indexPath = popularCollectionView.indexPath(for: cell)
            let selected = recipeList[(indexPath?.row)!]
            vc?.recipe = selected
        }
        if segue.identifier == "recommendedToRecipeSegue" {
            let vc = segue.destination as? RecipePageViewController
            let cell = sender as! RecommendedCustomViewCell
            let indexPath = recommendedCollectionView.indexPath(for: cell)
            let selected = recommendedList[(indexPath?.row)!]
            vc?.recipe = selected
        }
        if segue.identifier == "AdvancedSearchPopover" {
            let vc = segue.destination as? SearchFilterPopoverViewController
            vc?.isModalInPopover = true
            vc?.searchFilterDelegate = self
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
            }
        }
        if segue.identifier == "homeToRecipeList" {
            let vc = segue.destination as! HistoryFavoriteSearchResultsViewController
            vc.recipeList = passedRecipes
            
            // 0 is myRecipes, 1 is removeRecipe
            if whichRecipeClick == 0 {
                vc.whichRecipeClicked = 0
            }
            else if whichRecipeClick == 1 {
                vc.whichRecipeClicked = 1
            }
            else if whichRecipeClick == 2 {
                vc.whichRecipeClicked = 2
            } else if whichRecipeClick == 3 {
                vc.whichRecipeClicked = 3
            }
        }
        
        menu.alpha = 0.0
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tvSearchAutofill) {
            return autofillRecipes.count
        } else {
            return categoryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tvSearchAutofill) {
            let row = indexPath.row
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeAutofillCell", for: indexPath)
            cell.textLabel?.text = autofillRecipes[row].name
            cell.detailTextLabel?.text = autofillRecipes[row].category
            return cell
        } else {
            let cell:HomeCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "categoryTableCell", for: indexPath as IndexPath) as! HomeCategoryTableViewCell
            
            
            let row = indexPath.row
            cell.cuisineImage.image = categoryImages[row]
            cell.categoryName.text = categoryList[row]
            return cell
        }
    }
    
    func setSearchFilter(query: String) {
        searchFilter = query
    }
    
    @IBAction func onMenuButtonClick(_ sender: Any) {
        if menu.alpha == 0 {
            menu.alpha = 1
        } else {
            menu.alpha = 0
        }
    }
    
    func updateUser(newUser: User) {
        currentUser = newUser
        self.navigationController?.popViewController(animated: true)
    }
    
    // Navigate to different controller screens
    @IBAction func onMenuProfile(_ sender: Any) {
        performSegue(withIdentifier: "homeToProfile", sender: sender)
    }
    
    @IBAction func onMenuSettings(_ sender: Any) {
        performSegue(withIdentifier: "homeToSettings", sender: sender)
    }
    @IBAction func onMenuLegalClick(_ sender: Any) {
        performSegue(withIdentifier: "homeToLegal", sender: sender)
    }
    
    @IBAction func onCreditsClick(_ sender: Any) {
        performSegue(withIdentifier: "homeToCredits", sender: sender)
    }
    
    @IBAction func onMenuLogout(_ sender: Any) {
        currentUser.clear()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onMenuShoppingListClick(_ sender: Any) {
        performSegue(withIdentifier: "homeToShoppingList", sender: sender)
    }
    @IBAction func onMenuPantryClick(_ sender: Any) {
        performSegue(withIdentifier: "homeToPantry", sender: sender)
    }
    @IBAction func onMenuRecipeClick(_ sender: Any) {
        self.whichRecipeClick = 0
//        passedRecipes = getRecipes(query: "uid=\(currentUser.getId())")
        performSegue(withIdentifier: "homeToRecipeList", sender: sender)
        menu.alpha = 0
    }
    @IBAction func onMenuFavoriteClick(_ sender: Any) {
        self.whichRecipeClick = 2
        performSegue(withIdentifier: "homeToRecipeList", sender: sender)
    }
    @IBAction func onMenuMealsClick(_ sender: Any) {
        performSegue(withIdentifier: "homeToMeals", sender: sender)
    }
    @IBAction func onMenuRemoveRecipeClick(_ sender: Any) {
        self.whichRecipeClick = 1
        passedRecipes = getRecipes(query: "uid=\(currentUser.getId())")
        performSegue(withIdentifier: "homeToRecipeList", sender: sender)
    }
    @IBAction func onMenuAddRecipeClick(_ sender: Any) {
        performSegue(withIdentifier: "homeToAddRecipe", sender: sender)
    }
    
    @IBAction func onSearchSubmit(_ sender: Any) {
        var query = ""
        searchString = "name LIKE '%\(txtSearch.text!)%'"
        if(searchString != "") {
            if(searchFilter != "") {
                query = "\(searchString) AND \(searchFilter)"
            } else {
                query = searchString
            }
        } else if(searchFilter != "") {
            query = searchFilter
        }
        if(query != "") {
            passedRecipes = getRecipes(query: query)
            whichRecipeClick = 3
            autofillRecipes.removeAll()
            tvSearchAutofill.isHidden = true
            performSegue(withIdentifier: "homeToRecipeList", sender: sender)
        }
    }
    
    
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        if(tableView == tvSearchAutofill) {
            if(!self.selectedRecipe.getRecipe(rid: autofillRecipes[indexPath.row].id)) {
                autofillRecipes.removeAll()
                tvSearchAutofill.isHidden = true
                self.performSegue(withIdentifier: "homeToRecipeOverview", sender: self)
            }
        } else {
            self.thisRow = indexPath.row
            performSegue(withIdentifier: "homeToCuisineSegue", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }

    }
    
    func changeSidebarColor(color: UIColor) {
        self.menu.backgroundColor = color
    }
    
    @objc func nameDidChange(_ textField :UITextField) {
        self.autofillRecipes.removeAll()
        if(txtSearch.text! != "") {
            if(!recipeAutofill(str: txtSearch.text!)) {
                tvSearchAutofill.reloadData()
            } else {
                print(self.eMsg)
            }
        } else {
            self.autofillRecipes.removeAll()
            tvSearchAutofill.reloadData()
            tvSearchAutofill.isHidden = true
        }
        if(autofillRecipes.count > 0) {
            tvSearchAutofill.isHidden = false
            tvSearchAutofill.reloadData()
        } else {
            tvSearchAutofill.isHidden = true
        }
    }
    
    func recipeAutofill(str:String) -> Bool {
        // create a variable to return whether we errored out or not
        var vError : Bool = false
        
        // path to our backend script
        let URL_VERIFY = "http://www.teragentech.net/prepmate/AutofillRecipe.php"
        
        // variable which will spin until verification is finished
        var finished : Bool = false
        
        // create our URL object
        let url = URL(string: URL_VERIFY)
        
        // create the request and set the type to POST, otherwise we get authorization error
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let params = "str=\(str)"
        
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        // Create a task and send our request to our REST API
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            // if we error out, return the error message
            if(error != nil) {
                self.eMsg = error!.localizedDescription
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
                    self.eMsg = parseJSON["msg"] as! String
                    vError = (parseJSON["error"] as! Bool)
                    if(!vError) {
                        var count = 0
                        while let record = parseJSON[String(count)] as? NSString {
                            if let entry = try JSONSerialization.jsonObject(with: record.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as? NSDictionary {
                                var newR = (id : 0, name : "", category : "")
                                if let strId = entry["id"] as? String {
                                    newR.id = Int(strId)!
                                    newR.name = entry["name"] as! String
                                    if let strCat = entry["category"] as? String {
                                        newR.category = categoryList[Int(strCat)!]
                                        self.autofillRecipes.append(newR)
                                    } else {
                                        vError = true
                                        self.eMsg = "An error occured while parsing category"
                                        return
                                    }
                                } else {
                                    self.eMsg = "An error occured while parsing id"
                                    vError = true
                                    return
                                }
                            }
                            count+=1
                        }
                    }
                }
            } catch {
                self.eMsg = error.localizedDescription
                vError = true
            }
            finished = true
        }
        // execute our task and then return the results
        task.resume()
        while(!finished) {}
        return vError
    }
}
