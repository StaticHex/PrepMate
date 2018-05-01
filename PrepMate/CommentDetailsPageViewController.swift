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
    let creator = User()
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

        if(!creator.getUser(uid: comment.userId)) {
            authorLabel.setTitle(creator.getUname(), for: .normal)
        } else {
            authorLabel.setTitle("I AM ERROR", for: .normal)
        }
        dateLabel.text! = self.comment.date
        commentBody.text! = self.comment.description
        self.title = self.comment.title
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentToUser",
            let vc = segue.destination as? UserProfileViewController{
            vc.op = 2
            vc.user = creator
            vc.avatarPhoto.setPhoto(imageURL: creator.getPhotoURL())
        }
    }

}
