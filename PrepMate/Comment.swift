//
//  Comment.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation
class Comment {
    private var id : Int
    private var title : String
    private var author : User
    private var rating : Int
    private var description : String
    private var date: String
    init() {
        self.id = -1
        self.title = ""
        self.author = User()
        self.rating = -1
        self.description = ""
        self.date = getTimestamp()
    }
    init(id:Int, title:String, author: User, rating: Int, description: String) {
        self.id = id
        self.title = title
        self.author = author
        self.rating = rating
        self.description = description
        self.date = getTimestamp()
    }
    
    // Getter functions for class variables
    func getId() ->Int {return self.id}
    func getTitle() ->String {return self.title}
    func getAuthor() ->User {return self.author}
    func getRating() ->Int {return self.rating}
    func getDescription() ->String {return self.description}
    func getDate() -> String {return self.date}
   
    

        
}
