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
    @IBOutlet weak var authorLabel: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentBody: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPage()
        // Do any additional setup after loading the view.
    }
    @IBAction func onAuthorPressed(_ sender: Any) {
        // TODO: 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func loadPage() {
        self.ratingsLabel.image = RatingImages[self.comment.rating]
        let creator = User()
        if(!creator.getUser(uid: comment.userId)) {
            authorLabel.setTitle(creator.getUname(), for: .normal)
        } else {
            authorLabel.setTitle("I AM ERROR", for: .normal)
        }
        dateLabel.text! = self.comment.date
        commentBody.text! = self.comment.description
        self.title = self.comment.title
    }

}
