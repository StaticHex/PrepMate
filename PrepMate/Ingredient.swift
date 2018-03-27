//
//  Ingredient.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation
class Ingredient {
    public var id : Int
    public var name : String
    public var unit : Int
    public var customLabel : String
    init(id:Int, name: String, unit: Int, customLabel:String) {
        self.id = id
        self.name = name
        self.unit = unit
        self.customLabel = customLabel
    }
}
