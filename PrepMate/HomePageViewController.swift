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
    
    var appUser = User()

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
        }
        if segue.identifier == "homeToProfile" {
            let vc = segue.destination as? UserProfileViewController
            vc?.profileDelegate = self
            vc?.currentUser = appUser
            vc?.op = 1
            vc?.avatarPhoto.setPhoto(imageURL: appUser.getPhotoURL())
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
        appUser.copy(oldUser: newUser)
        self.navigationController?.popViewController(animated: true)
    }
    
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
        appUser.clear()
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
