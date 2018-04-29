//
//  SearchFilterPopoverViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/20/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

protocol SearchFilterProtocol : class {
    func setSearchFilter(query : String)
}
class SearchFilterPopoverViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // UI Component Outlets
    @IBOutlet weak var chkTreeNut: UIButton!
    @IBOutlet weak var chkEggs: UIButton!
    @IBOutlet weak var chkMilk: UIButton!
    @IBOutlet weak var chkGluten: UIButton!
    @IBOutlet weak var chkMeat: UIButton!
    @IBOutlet weak var chkPork: UIButton!
    @IBOutlet weak var chkButter: UIButton!
    @IBOutlet weak var chkPeanuts: UIButton!
    @IBOutlet weak var chkShellfish: UIButton!
    @IBOutlet weak var chkTomato: UIButton!
    @IBOutlet weak var chkSoy: UIButton!
    @IBOutlet weak var chkFish: UIButton!
    @IBOutlet weak var chkYeast: UIButton!
    @IBOutlet weak var chkSpicy: UIButton!
    @IBOutlet weak var chkHealthy: UIButton!
    @IBOutlet weak var chkHighFat: UIButton!
    @IBOutlet weak var chkVegetarian: UIButton!
    @IBOutlet weak var chkVegan: UIButton!
    @IBOutlet weak var pckCategory: UIPickerView!
    
    // delegate to return built query to parent
    weak var searchFilterDelegate : SearchFilterProtocol?
    
    var buttons = [UIButton]()
    var fields = ["has_tree_nutss", "has_eggs", "has_milk", "has_gluten", "has_meat",
                  "has_pork", "has_butter", "has_peanuts", "has_shellfish", "has_tomatoes",
                  "has_soy", "has_fish", "has_yeast", "is_spicy", "is_healthy",
                  "is_high_fat", "is_vegetarian", "is_vegan"]
    
    // alert for ingredient info
    let alert = UIAlertController(title: "Ingredient Info", message: "", preferredStyle: .alert)
    
    // category list
    var categories = [(title:String, idx:Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pckCategory.delegate = self
        pckCategory.dataSource = self
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        buttons = [chkTreeNut, chkEggs, chkMilk, chkGluten, chkMeat, chkPork,
                   chkButter, chkPeanuts, chkShellfish, chkTomato, chkSoy, chkFish,
                   chkYeast, chkSpicy, chkHealthy, chkHighFat, chkVegetarian, chkVegan]
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setup()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categories[row].title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Nav. Bar actions
    @IBAction func onApply(_ sender: Any) {
        searchFilterDelegate?.setSearchFilter(query: buildQuery())
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Check Box Actions
    @IBAction func onTreeNutCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onEggCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    
    @IBAction func onMilkCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onGlutenCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onMeatCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onPorkCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onButterCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onPeanutCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onShellfishCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onTomatoCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onSoyCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onFishCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onYeastCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onSpicyCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onHealthyCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onHFatCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onVegetarianCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    @IBAction func onVeganCheck(_ sender: Any) {
        checkbox(component: sender as! UIButton)
    }
    
    // Info Actions, for alerts
    @IBAction func infoTreeNut(_ sender: Any) {
        alert.title = "Tree Nuts"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoEgg(_ sender: Any) {
        alert.title = "Eggs"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoMilk(_ sender: Any) {
        alert.title = "Milk"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoWheat(_ sender: Any) {
        alert.title = "Gluten"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoMeat(_ sender: Any) {
        alert.title = "Meat"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoPork(_ sender: Any) {
        alert.title = "Pork"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoButter(_ sender: Any) {
        alert.title = "Butter"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoPeanuts(_ sender: Any) {
        alert.title = "Peanuts"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoShellfish(_ sender: Any) {
        alert.title = "Shellfish"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoTomato(_ sender: Any) {
        alert.title = "Tomato"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoSoy(_ sender: Any) {
        alert.title = "Soy"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoFish(_ sender: Any) {
        alert.title = "Fish"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoYeast(_ sender: Any) {
        alert.title = "Yeast"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoSpicy(_ sender: Any) {
        alert.title = "Spicy Recipe"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoHealthy(_ sender: Any) {
        alert.title = "Healthy Recipe"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoHFat(_ sender: Any) {
        alert.title = "High Fat Recipe"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoVegetarian(_ sender: Any) {
        alert.title = "Vegetarian"
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func infoVegan(_ sender: Any) {
        alert.title = "Vegan"
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkbox(component : UIButton) {
        if(component.title(for: .normal)=="□") {
            component.setTitle("■", for: .normal)
        } else if(component.title(for: .normal)=="■"){
            component.setTitle("☒", for: .normal)
        } else {
            component.setTitle("□", for: .normal)
        }
    }
    
    func setup() {
        // Reset Category List and buttons
        self.categories.removeAll()
        
        var newCat = [(title : String, idx : Int)]()
        newCat.append((title: "None", idx: -1))
        var end = categoryList.count
        for i in 0..<end {
            newCat.append((title: categoryList[i], idx: i))
        }
        resetFlags()
        
        // create new flag bit vector
        var blFlags = 0
        
        // get preference list
        end = currentUser.getPrefCount()
        for i in 0..<end {
            let p = currentUser.getPref(idx: i)
            switch(p.key) {
            case "Category":
                newCat[p.value + 1].title = ""
                break
            case "Ingredient":
                blFlags += ingredientList[p.value].flag
                break
            case "Type":
                blFlags += foodTypeList[p.value].flag
                break
            default:
                break
            }
        }
        
        // set flags
        setFlags(flags: blFlags)
        
        // create new categories list and copy it over

        for c in newCat {
            if c.title != "" {
                self.categories.append(c)
            }
        }
        pckCategory.reloadComponent(0)
    }
    
    func setFlags(flags : Int) {
        var idx = 0
        var f = flags
        while f > 0 {
            if (f & 1) == 1 {
                buttons[idx].setTitle("☒", for: .normal)
                buttons[idx].isEnabled = false
            }
            f >>= 1
            idx += 1
        }
    }
    
    func resetFlags() {
        let end = buttons.count
        for i in 0..<end {
            buttons[i].setTitle("□", for: .normal)
            buttons[i].isEnabled = true
        }
    }
    
    func buildQuery() -> String {
        var query = ""
        let cat = pckCategory.selectedRow(inComponent: 0)
        if(cat > 0) {
            query += "category=\(self.categories[cat].idx)"
        }
        if query != "" {
            query += " AND "
        }
        
        let end = buttons.count
        for i in 0..<end {
            if(buttons[i].title(for: .normal)=="☒") {
                query += "\(fields[i])='false' AND "
            } else if(buttons[i].title(for: .normal)=="■"){
                query += "\(fields[i])='true' AND "
            }
        }
        query = substring(tok: query, begin: 0, end: query.count - 5)
        return query
    }
}
