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
    @IBOutlet weak var commentTitle: UINavigationItem!
    @IBOutlet weak var ratingsLabel: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
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
        //TODO: Implement ratings
        //self.ratingsLabel.image
        authorLabel.text! = self.comment.getAuthor().getFname() + " " + self.comment.getAuthor().getLname()
        dateLabel.text! = self.comment.getDate()
        timeLabel.text! = self.comment.getTime()
        commentBody.text! = self.comment.getDescription()
        commentTitle.title = self.comment.getTitle()

    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        //TODO implement back button:w
        
    }

}
