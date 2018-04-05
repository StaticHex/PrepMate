//
//  RecipeNutritionViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit

/// Class for nutrition collection view cell
class nutritionOverviewCell: UICollectionViewCell {
    // Image contained within each cell
    @IBOutlet weak var nutritionImage: UIImageView!
}

class RecipeNutritionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var recipe = Recipe()
    var nutritionList = [UIImage]()
    
    // Outlets
    @IBOutlet weak var nutritionCollectionView: UICollectionView!
    @IBOutlet weak var basicInfoText: UITextView!
    @IBOutlet weak var vitaminInfoText: UITextView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nutritionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nutritionOverviewCell", for: indexPath as IndexPath) as! nutritionOverviewCell
        let row = indexPath.row
        cell.nutritionImage.image = self.nutritionList[row]
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.basicInfoText.layer.borderWidth = 1
        self.vitaminInfoText.layer.borderWidth = 1
        var flagNum = self.recipe.getFlags()
        for i in 0...(nutritionImages.count-1){
            if (flagNum & 1 ) == 1 {
                self.nutritionList.append(nutritionImages[i])
            }
            flagNum = flagNum >> 1
        }
        nutritionCollectionView.delegate = self
        nutritionCollectionView.dataSource = self
        self.basicInfoText.text! = self.loadBasicInfo()
        self.vitaminInfoText.text! = self.loadVitaminInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadBasicInfo() -> String {
        let maxWidth = 40
        var headerString = "Amount"
        var dataDict = self.recipe.getBasicInfo()
        headerString = headerString.padding(toLength: maxWidth, withPad: " ", startingAt: 0)
        headerString =  headerString + "Daily Value %\n\n"
        var result = headerString
        for key in dataDict.keys {
            var tmp = key + ": \(dataDict[key]!)g"
            tmp = tmp.padding(toLength: maxWidth, withPad: " ", startingAt:0)
            // TODO: Change this to use FDA default values
            tmp = tmp + "20%\n"
            result = result + tmp
        }
        return result
    }
    
    
    func loadVitaminInfo() -> String {
        let maxWidth = 20
        var headerString = "Amount"
        headerString = headerString.padding(toLength: maxWidth, withPad: " ", startingAt: 0)
        headerString =  headerString + "Daily Value %\n\n"
        var result = headerString
        for vitamin in self.recipe.getVitamins() {
            var tmp = vitaminList[vitamin.getIndex()]
            tmp = tmp.padding(toLength: 20, withPad: " ", startingAt:0)
            tmp = tmp + "\(vitamin.getPercent())%\n"
            result = result + tmp
        }
        return result
    }
    


}
