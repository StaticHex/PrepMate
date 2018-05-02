//
//  RecipeNutritionViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

// Nutrition Overview Cell
// @description
// - A custom UICollectionViewCell that shows associated nutrition images for a recipe
class nutritionOverviewCell: UICollectionViewCell {
    // Image contained within each cell
    @IBOutlet weak var nutritionImage: UIImageView!
}
// A UIViewController that represents the nutrition container view of the Recipe page
class RecipeNutritionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    // Current Recipe
    var recipe = Recipe()
    // List of associated nutrition images
    var nutritionList = [UIImage]()
    // The collection view that displays the associated nutrition images
    @IBOutlet weak var nutritionCollectionView: UICollectionView!
    // The textview that displays the basic information about the recipe
    @IBOutlet weak var basicInfoText: UITextView!
    // The textview that displays the vitamin information about the recipe
    @IBOutlet weak var vitaminInfoText: UITextView!
    
    // A required function for UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nutritionList.count
    }
    // A required function for UICollectionView that determines how cells are displayed
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nutritionOverviewCell", for: indexPath as IndexPath) as! nutritionOverviewCell
        let row = indexPath.row
        cell.nutritionImage.image = self.nutritionList[row]
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add a border around the textviews
        self.basicInfoText.layer.borderWidth = 1
        self.vitaminInfoText.layer.borderWidth = 1
        // Parse the associated nutrition items from the recipe
        var flagNum = self.recipe.getFlags()
        for i in (0...(nutritionImages.count-1)).reversed(){
            if (flagNum & 1 ) == 1 {
                self.nutritionList.append(nutritionImages[i])
            }
            flagNum = flagNum >> 1
        }
        nutritionCollectionView.delegate = self
        nutritionCollectionView.dataSource = self
        // Load the basic and vitamin recipe information into the textviews
        self.basicInfoText.text! = self.loadBasicInfo()
        self.vitaminInfoText.text! = self.loadVitaminInfo()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Load Basic Info Function
    // @description
    // - Formats the basic recipe info to be displayed in the textview
    // @return
    // - The formatted string to populated the textview
    func loadBasicInfo() -> String {
        let maxWidth = 30
        var headerString = "Amount"
        var dataDict = self.recipe.getNutritionDict()
        headerString = headerString.padding(toLength: maxWidth, withPad: " ", startingAt: 0)
        headerString =  headerString + "Daily Value %\n\n"
        var result = headerString
        for key in dataDict.keys {
            var tmp = key + ": \(dataDict[key]!.amount)g"
            tmp = tmp.padding(toLength: maxWidth, withPad: " ", startingAt:0)
            tmp = tmp + "\(dataDict[key]!.percent)%\n"
            result = result + tmp
        }
        return result
    }
    
    // Load  Info Function
    // @description
    // - Formats the recipe vitamin info to be displayed in the textview
    // @return
    // - The formatted string to populated the textview
    func loadVitaminInfo() -> String {
        let maxWidth = 30
        var headerString = "Amount"
        headerString = headerString.padding(toLength: maxWidth, withPad: " ", startingAt: 0)
        headerString =  headerString + "Daily Value %\n\n"
        var result = headerString
        for i in 0..<self.recipe.getNumVitamin() {
            let vitamin = recipe.getRecipeVitamin(idx: i)
            var tmp = vitaminList[vitamin.idx]
            tmp = tmp.padding(toLength: maxWidth, withPad: " ", startingAt:0)
            tmp = tmp + "\(vitamin.percent)%\n"
            result = result + tmp
        }
        return result
    }

}
