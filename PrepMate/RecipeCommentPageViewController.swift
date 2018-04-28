//
//  RecipeCommentPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//
class RecipeCommentCell: UITableViewCell {
    
    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var ratingsLabel: UIImageView!
    @IBOutlet weak var commentPreview: UITextView!
}
import UIKit
class RecipeCommentPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, addCommentProtocol, sortCommentProtocol{
    
    @IBOutlet weak var recipeCommentTableView: UITableView!
    var recipe = Recipe()
    var sortOption = 0
    var enabledStars = [true, true, true, true, true]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipe.getNumComment()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCommentCell", for: indexPath as IndexPath) as! RecipeCommentCell
        let row = indexPath.row
        let curr = self.recipe.getRecipeComment(idx: row)
        cell.commentTitle.text! = curr.title
        cell.commentPreview.isScrollEnabled = false
        cell.commentPreview.allowsEditingTextAttributes = false
        cell.commentPreview.text! = curr.description
        cell.ratingsLabel.image = RatingImages[curr.rating]
        return cell
    }
    func addComment(comment: Comment) {
        if(self.recipe.addRecipeComment(newComment: comment)) {
            print(recipe)
        }
        self.recipeCommentTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeCommentTableView.delegate = self
        recipeCommentTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func onPressAdvanced(_ sender: Any) {
        performSegue(withIdentifier: "advancedPopoverSegue", sender: sender)
    }
    func sortDate(enabledStars: [Bool], sortOption: Int){
        print(self.recipe)
        self.enabledStars = enabledStars
        self.sortOption = sortOption
        var str = "AND rating IN (\(findEnabledStars(enabled: self.enabledStars)))"
        if(sortOption == 0){
            str = str + " ORDER BY date_posted ASC"
        } else {
            //Sort by oldest first
            str = str + " ORDER BY date_posted DESC"
        }
        self.recipe.getFilteredRecipeComments(query: str)
        self.recipeCommentTableView.reloadData()
    }
    func sortRating(enabledStars: [Bool], sortOption: Int) {
        self.enabledStars = enabledStars
        self.sortOption = sortOption
        var str = "AND rating IN (\(findEnabledStars(enabled: self.enabledStars)))"
        if(sortOption == 3){
            str = str + "ORDER BY rating ASC"
        } else {
            //Sort by highest rating first
            str = str + "ORDER BY rating DESC"
        }
        self.recipe.getFilteredRecipeComments(query: str)
        self.recipeCommentTableView.reloadData()
    }
    private func findEnabledStars(enabled: [Bool]) -> String {
        var results = [String]()
        if(enabled[0]){
            results = ["0", "1", "2", "3"]
        }
        for i in 1..<enabled.count {
            if(enabled[i]){
                results.append("\((i+1)*2)")
                if(i < enabled.count - 1){
                    results.append("\((i+1)*2+1)")
                }
            }
        }
        return "\(results.joined(separator: ", "))"
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "commentPageToCommentDetail",
            let destination = segue.destination as? CommentDetailsPageViewController,
            let operatorIndex = recipeCommentTableView.indexPathForSelectedRow?.row
        {
            destination.comment = self.recipe.getRecipeComment(idx: operatorIndex)        }
        else if segue.identifier == "addCommentSegue" {
            let vc = segue.destination as? NewCommentPopoverViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.addCommentDelegate = self
            }
        }
        else if segue.identifier == "advancedPopoverSegue"{
            let vc = segue.destination as? CommentFilterPopoverViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.sortCommentDelegate = self
                vc?.selectedOption = self.sortOption
                vc?.starSortVector = self.enabledStars
            }
        }
    }

}
