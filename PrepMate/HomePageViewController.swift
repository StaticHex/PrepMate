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

class HomePageViewController: UIViewController, settingsProtocol, ProfileProtocol {
    
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
    
    var currentUser = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        menu.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "titleBarColor") != nil {
            let decoded  = defaults.object(forKey: "titleBarColor") as! Data
            let decodedColor = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UIColor
            self.menu.backgroundColor = decodedColor
        }

        if defaults.object(forKey: "navBarTextColor") != nil {
            let decoded  = defaults.object(forKey: "navBarTextColor") as! Data
            let decodedColor = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UIColor
            
            // TODO ADD OUTLETS HERE!!!!
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "logoutToLogin") {
            // TODO: Destroy user object and set up login
        }
        if segue.identifier == "homeToSettings" {
            let vc = segue.destination as? SettingsViewController
            vc?.sDelegate = self
            vc?.currentUser = currentUser
        }
        if segue.identifier == "homeToProfile" {
            let vc = segue.destination as? UserProfileViewController
            vc?.profileDelegate = self
            vc?.currentUser = currentUser
            vc?.op = 1
            vc?.avatarPhoto.setPhoto(imageURL: currentUser.getPhotoURL())
        }
        menu.alpha = 0.0
    }

    @IBAction func onMenuButtonClick(_ sender: Any) {
        if menu.alpha == 0 {
            menu.alpha = 1
        } else {
            menu.alpha = 0
        }
    }
    
    func updateUser(newUser: User) {
        currentUser.copy(oldUser: newUser)
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
    
    func changeSidebarColor(color: UIColor) {
        self.menu.backgroundColor = color
    }
}
