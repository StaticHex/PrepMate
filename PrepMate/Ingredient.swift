//
//  Ingredient.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation
class Ingredient {
    private var id : Int
    private var name : String
    private var unit : Int
    private var customLabel : String
    init(id:Int, name: String, unit: Int, customLabel:String) {
        self.id = id
        self.name = name
        self.unit = unit
        self.customLabel = customLabel
    }
    
    func getId() -> Int { return self.id}
    func getName() -> String { return self.name}
    //TODO: change this to correctly reflect type of units
    func getUnit() -> Int { return self.unit}
    func getCustomLabel() -> String { return self.customLabel}
}
