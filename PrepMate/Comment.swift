//
//  Comment.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation
class Comment {
    public var id : Int
    public var title : String
    public var author : User
    public var rating : Int
    public var description : String
    init(id:Int, title:String, author: User, rating: Int, description: String) {
        self.id = id
        self.title = title
        self.author = author
        self.rating = rating
        self.description = description
    }
}
