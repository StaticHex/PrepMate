//
//  CommentDetailsPageViewController.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import UIKit
class CommentDetailsPageViewController: UIViewController {
    var comment = Comment()
    
    // Outlets
    @IBOutlet weak var ratingsLabel: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentBody: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func loadPage() {
        self.ratingsLabel.image = RatingImages[self.comment.rating]
        let creator = User()
        if(!creator.getUser(uid: comment.userId)) {
            authorLabel.text! = creator.getUname()
        } else {
            authorLabel.text! = "I AM ERROR"
        }
        dateLabel.text! = self.comment.date
        commentBody.text! = self.comment.description
        self.title = self.comment.title
    }

}
