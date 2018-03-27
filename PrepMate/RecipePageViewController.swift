//
//  RecipePageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

class RecipePageViewController: UIViewController {

    @IBOutlet weak var RecipeOverviewView: UIView!
    @IBOutlet weak var RecipeNutritionView: UIView!
    @IBOutlet weak var RecipeCommentView: UIView!
    @IBAction func onSegmentPressed(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){
            // Overview segment selected
            UIView.animate(withDuration: 0.5, animations: {
                self.RecipeOverviewView.alpha = 1
                self.RecipeNutritionView.alpha = 0
                self.RecipeCommentView.alpha = 0
            })
        } else if(sender.selectedSegmentIndex == 1) {
            // Nutrition info segment selected
            UIView.animate(withDuration: 0.5, animations: {
                self.RecipeOverviewView.alpha = 0
                self.RecipeNutritionView.alpha = 1
                self.RecipeCommentView.alpha = 0
            })
        } else {
            // Comment segment selected
            UIView.animate(withDuration: 0.5, animations: {
                self.RecipeOverviewView.alpha = 0
                self.RecipeNutritionView.alpha = 0
                self.RecipeCommentView.alpha = 1
            })
        }
    }
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
