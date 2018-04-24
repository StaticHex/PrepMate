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
    var comments = [Comment]()
    var sortOption = 0
    var enabledStars = [true, true, true, true, true]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCommentCell", for: indexPath as IndexPath) as! RecipeCommentCell
        let row = indexPath.row
        cell.commentTitle.text! = comments[row].title
        cell.commentPreview.isScrollEnabled = false
        cell.commentPreview.allowsEditingTextAttributes = false
        cell.commentPreview.text! = comments[row].description
        // TODO: How do we populate the rating?
        cell.ratingsLabel.image = RatingImages[comments[row].rating]
        return cell
    }
    func addComment(comment: Comment) {
        // TODO: Update the db?
        if(self.recipe.addRecipeComment(newComment: comment)) {
            print(recipe)
        }
        self.recipeCommentTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeCommentTableView.delegate = self
        recipeCommentTableView.dataSource = self
        // Do any additional setup after loading the view.
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
    func sortDate(ascend:Bool, enabledStars: [Bool], sortOption: Int){
        if(ascend){
            //Sort by most recent date
        } else {
            //Sort by oldest first
        }
        
    }
    func sortRating(ascend:Bool, enabledStars: [Bool], sortOption: Int) {
        if(ascend){
            //Sort by lowest rating first
        } else {
            //Sort by highest rating first
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "commentPageToCommentDetail",
            let destination = segue.destination as? CommentDetailsPageViewController,
            let operatorIndex = recipeCommentTableView.indexPathForSelectedRow?.row
        {
            destination.comment = comments[operatorIndex]
        }
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
