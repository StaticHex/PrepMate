//
//  RecipeOverviewViewController.swift
//  PrepMate
//
//  Created by Pablo Velasco on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class RecipeOverviewViewController: UIViewController {

    /// When Favorite button is pressed
    @IBAction func onFavoritePressed(_ sender: Any) {
    
    }
    @IBAction func onAddPressed(_ sender: Any) {
    }
    @IBOutlet weak var ratingsImage: UIImageView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientText: UITextView!
    @IBOutlet weak var directionsText: UITextView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var preptimeLabel: UILabel!
    @IBOutlet weak var cooktimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
