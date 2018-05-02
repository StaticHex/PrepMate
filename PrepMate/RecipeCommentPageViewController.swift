//
//  RecipeCommentPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/21/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//
import UIKit

// Recipe Comment Cell
// @description
// - A custom UITableViewCell that represents a recipe comment shown in the comment tableview
class RecipeCommentCell: UITableViewCell {
    // Label displaying the title of the comment
    @IBOutlet weak var commentTitle: UILabel!
    // Label displaying the rating in the comment
    @IBOutlet weak var ratingsLabel: UIImageView!
    // Textview that displays a short preview of the comment body
    @IBOutlet weak var commentPreview: UITextView!
}

// ViewController class for the Recipe Comment container view
class RecipeCommentPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, addCommentProtocol, sortCommentProtocol{
    
    // Outlet for tableview displaying all the recipe comments
    @IBOutlet weak var recipeCommentTableView: UITableView!
    // Holds the current recipe
    var recipe = Recipe()
    // Integer that holds the current sort by option selected in the comment filter
    var sortOption = 0
    // Bool array that keeps track of which star comments to include (set in the comment filter)
    var enabledStars = [true, true, true, true, true]
    
    // Required function for the UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipe.getNumComment()
    }
    // Required function for the UITableView that displays each Cell
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
    // Add Comment Function
    // @params
    // - comment: (Comment) The new comment to add
    // @description
    // - A Protocol/Delegate function that adds a new comment from the AddCommentPopover view
    func addComment(comment: Comment) {
        if(self.recipe.addRecipeComment(newComment: comment)) {
            print(recipe.getEMsg())
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
    // Action when the advanced button is pressed to segue to the comment filter
    @IBAction func onPressAdvanced(_ sender: Any) {
        performSegue(withIdentifier: "advancedPopoverSegue", sender: sender)
    }
    // Sort Date Function
    // @params
    // - enabledStars: ([Bool]) A Bool array that specifies which star ratings to show
    // - sortOption: (Int) The sort by option selected
    // @description
    // - A Protocol/Delegate function called when the user decides to sort the comment by date
    // through the comment filter
    func sortDate(enabledStars: [Bool], sortOption: Int){
        self.enabledStars = enabledStars
        self.sortOption = sortOption
        // Build the query to pass to the db function
        var str = "AND rating IN (\(findEnabledStars(enabled: self.enabledStars)))"
        if(sortOption == 0){
            // Sort by most recent
            str = str + " ORDER BY date_posted ASC;"
        } else {
            // Sort by oldest first
            str = str + " ORDER BY date_posted DESC;"
        }
        // Database function call to query new set of comments
        self.recipe.getFilteredRecipeComments(query: str)
        self.recipeCommentTableView.reloadData()
    }
    // Sort Date Function
    // @params
    // - enabledStars: ([Bool]) A Bool array that specifies which star ratings to show
    // - sortOption: (Int) The sort by option selected
    // @description
    // - A Protocol/Delegate function called when the user decides to sort the comment by rating
    // through the comment filter
    func sortRating(enabledStars: [Bool], sortOption: Int) {
        self.enabledStars = enabledStars
        self.sortOption = sortOption
        var str = "AND rating IN (\(findEnabledStars(enabled: self.enabledStars)))"
        if(sortOption == 3){
            // Sort by lowest rating first
            str = str + " ORDER BY rating ASC;"
        } else {
            // Sort by highest rating first
            str = str + " ORDER BY rating DESC;"
        }
        self.recipe.getFilteredRecipeComments(query: str)
        self.recipeCommentTableView.reloadData()
    }
    // Find Enabled Stars Function
    // @params
    // - enabled: (Bool) The Bool array that specifies which star ratings to show
    // @description
    // - A helper function for the sortDate/sortRating functions that converts the info in
    // the `enabled` array into a String that is ready for a db query.
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "commentPageToCommentDetail",
            let destination = segue.destination as? CommentDetailsPageViewController,
            let operatorIndex = recipeCommentTableView.indexPathForSelectedRow?.row
        {
            // Pass the selected comment to the Comment Detail Page
            destination.comment = self.recipe.getRecipeComment(idx: operatorIndex)}
        else if segue.identifier == "addCommentSegue" {
            // Segue to the NewCommentPopover
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
            // Segue to the comment filter
            let vc = segue.destination as? CommentFilterPopoverViewController
            vc?.isModalInPopover = true
            let controller = vc?.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
                controller?.passthroughViews = nil
                vc?.sortCommentDelegate = self
                // Pass the current sort settings
                vc?.selectedOption = self.sortOption
                vc?.starSortVector = self.enabledStars
            }
        }
    }

}
