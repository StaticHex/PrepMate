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
        for i in 0...(nutritionImages.count-1){
            if self.recipe.getFlags() & 1 << i == 1 {
                self.nutritionList.append(nutritionImages[i])
            }
        }
        self.basicInfoText.text! = self.loadBasicInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadBasicInfo() -> String {
        let maxWidth = 20
        var headerString = "Amount"
        var result = headerString.padding(toLength: maxWidth, withPad: " ", startingAt: 0)
        result = result + "Daily Value %\n"
        
        

        
        return result
        
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
