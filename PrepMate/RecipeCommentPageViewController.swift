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
class RecipeCommentPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var recipeCommentTableView: UITableView!
    var recipe = Recipe()
    var comments = [Comment]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCommentCell", for: indexPath as IndexPath) as! RecipeCommentCell
        let row = indexPath.row
        cell.commentTitle.text! = comments[row].getTitle()
        cell.commentPreview.isScrollEnabled = false
        cell.commentPreview.allowsEditingTextAttributes = false
        cell.commentPreview.text! = comments[row].getDescription()
        // TODO: How do we populate the rating?
        //cell.ratingsLabel.image =
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comments = self.recipe.getComments()
        recipeCommentTableView.delegate = self
        recipeCommentTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }

}
