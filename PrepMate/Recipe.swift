//
//  Recipe.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation

class Recipe {
    public var id : Int
    public var name : String
    public var photo : URL
    public var category : Int
    public var servings : Int
    public var prepTime : Int
    public var cookTime : Int
    public var calories : Int
    public var unsatFat : Int
    public var satFat : Int
    public var cholesterol : Int
    public var sodium : Int
    public var potassium : Int
    public var carbs : Int
    public var fiber : Int
    public var sugar : Int
    public var comments : [Comment]
    public var ingredients : [Ingredient]
    public var directions : [String]
    public var flags: Bool
    public var vitamin : [Vitamin]
    init(id:Int, name:String, photo:URL, category:Int, servings:Int, prepTime:Int, cookTime:Int, calories:Int, unsatFat:Int, satFat:Int, cholesterol:Int, sodium:Int, potassium:Int, carbs:Int, fiber:Int, sugar:Int, comments:[Comment], ingredients:[Ingredient], directions:[String], flags:Bool, vitamin:[Vitamin]) {
        self.id = id
        self.name = name
        self.photo = photo
        self.category = category
        self.servings = servings
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.calories = calories
        self.unsatFat = unsatFat
        self.satFat = satFat
        self.cholesterol = cholesterol
        self.sodium = sodium
        self.potassium = potassium
        self.carbs = carbs
        self.fiber = fiber
        self.sugar = sugar
        self.comments = comments
        self.ingredients = ingredients
        self.directions = directions
        self.flags = flags
        self.vitamin = vitamin
    }
}
