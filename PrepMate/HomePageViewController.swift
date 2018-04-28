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

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, settingsProtocol, ProfileProtocol {
    
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
    
    @IBOutlet weak var popularLabel: UILabel!
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    var thisRow = 0
    var recipeList = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.alpha = 0
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        recommendedCollectionView.dataSource = self
        recommendedCollectionView.delegate = self
        popularCollectionView.tag = 1
        recommendedCollectionView.tag = 2
        recipeList = getRecipes(query: "id>=1 ORDER BY rating ASC LIMIT 10")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(categoryList.count)
        print(categoryImages.count)
        
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recipeList.count
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
            
            cell.foodTitle.text = self.recipeList[row].getName().capitalized
            cell.foodImage.image = self.recipeList[row].getPhoto()
            cell.foodImage.contentMode = .scaleAspectFill
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "logoutToLogin") {
            // TODO: Destroy user object and set up login
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
        }
        if segue.identifier == "homeToCuisineSegue" {
            let vc = segue.destination as? HistoryFavoriteSearchResultsViewController
            vc?.row = self.thisRow
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
            let cell = sender as! PopularCustomViewCell
            let indexPath = popularCollectionView.indexPath(for: cell)
            let selected = recipeList[(indexPath?.row)!]
            vc?.recipe = selected
        }
        
        menu.alpha = 0.0
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HomeCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "categoryTableCell", for: indexPath as IndexPath) as! HomeCategoryTableViewCell
        
        
        let row = indexPath.row
        cell.cuisineImage.image = categoryImages[row]
        cell.categoryName.text = categoryList[row]
        return cell
        
        
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
        performSegue(withIdentifier: "homeToRecipeList", sender: sender)
        menu.alpha = 0
    }
    @IBAction func onMenuFavoriteClick(_ sender: Any) {
        performSegue(withIdentifier: "homeToRecipeList", sender: sender)
    }
    @IBAction func onMenuMealsClick(_ sender: Any) {
        performSegue(withIdentifier: "homeToMeals", sender: sender)
    }
    @IBAction func onMenuRemoveRecipeClick(_ sender: Any) {
        performSegue(withIdentifier: "homeToRecipeList", sender: sender)
    }
    @IBAction func onMenuAddRecipeClick(_ sender: Any) {
        performSegue(withIdentifier: "homeToAddRecipe", sender: sender)
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        self.thisRow = indexPath.row
        performSegue(withIdentifier: "homeToCuisineSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func changeSidebarColor(color: UIColor) {
        self.menu.backgroundColor = color
    }
}
