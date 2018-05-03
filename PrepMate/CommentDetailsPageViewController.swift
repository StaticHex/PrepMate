//
//  CommentDetailsPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit
// ViewController that displays the details of a comment
class CommentDetailsPageViewController: UIViewController {
    // Holds the current comment
    var comment = Comment()
    
    // Label that displays rating
    @IBOutlet weak var ratingsLabel: UIImageView!
    // Label that displays author
    @IBOutlet weak var authorLabel: UIButton!
    // Label that displays the date the comment was created
    @IBOutlet weak var dateLabel: UILabel!
    // Textview containing the body of the comment
    @IBOutlet weak var commentBody: UITextView!
    // Holds the creator of the comment
    let creator = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPage()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Populate the page with info from the Comment object
    private func loadPage() {
        self.ratingsLabel.image = RatingImages[self.comment.rating]

        if(!creator.getUser(uid: comment.userId)) {
            authorLabel.setTitle(creator.getUname(), for: .normal)
        } else {
            authorLabel.setTitle("I AM ERROR", for: .normal)
        }
        dateLabel.text! = self.comment.date
        commentBody.text! = self.comment.description
        self.title = self.comment.title
    }
    // If the author label is pressed, go to author's profile
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentToUser",
            let vc = segue.destination as? UserProfileViewController{
            vc.op = 2
            vc.user = creator
            vc.avatarPhoto.setPhoto(imageURL: creator.getPhotoURL())
        }
    }

}
