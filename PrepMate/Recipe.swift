//
//  Recipe.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation
import UIKit
class Recipe {
    private var id : Int
    private var name : String
    private var photo : Photo
    private var category : Int
    private var servings : Int
    private var prepTime : Int
    private var cookTime : Int
    private var calories : Int
    private var unsatFat : Int
    private var satFat : Int
    private var cholesterol : Int
    private var sodium : Int
    private var potassium : Int
    private var carbs : Int
    private var fiber : Int
    private var sugar : Int
    private var comments : [Comment]
    private var ingredients : [(id:Int,ing:Ingredient, amount:Float)]
    private var directions : [String]
    private var rating: Int
    private var flags: Int
    private var vitamin : [Vitamin]
    init() {
        self.id = -1
        self.name = ""
        self.photo = Photo()
        self.category = -1
        self.servings = -1
        self.prepTime = -1
        self.cookTime = -1
        self.calories = -1
        self.unsatFat = -1
        self.satFat = -1
        self.cholesterol = -1
        self.sodium = -1
        self.potassium = -1
        self.carbs = -1
        self.fiber = -1
        self.sugar = -1
        self.comments = [Comment]()
        self.ingredients = [(id:Int,ing:Ingredient, amount:Float)]()
        self.directions = [String]()
        self.rating = 0
        self.flags = 0
        self.vitamin = [Vitamin]()
    }
    init(id:Int, name:String, photo:Photo, category:Int, servings:Int, prepTime:Int, cookTime:Int, calories:Int, unsatFat:Int, satFat:Int, cholesterol:Int, sodium:Int, potassium:Int, carbs:Int, fiber:Int, sugar:Int, comments:[Comment], ingredients:[(id:Int, ing:Ingredient, amount:Float)], directions:[String], rating:Int, flags:Int, vitamin:[Vitamin]) {
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
        self.rating = rating
        self.flags = flags
        self.vitamin = vitamin
    }
    public func getId() -> Int { return self.id }
    public func getName() -> String { return self.name }
    public func getPhoto() -> UIImage { return self.photo.getImage()}
    public func getCategory() -> Int { return self.category}
    public func getServings() -> Int { return self.servings}
    // TODO: Possibly need to do processing for times over an hour
    public func getPrepTime() -> Int { return self.prepTime}
    public func getCookTime() -> Int { return self.cookTime}
    public func getCalories() -> Int { return self.calories}
    public func getUnsatFat() -> Int { return self.unsatFat}
    public func getSatFat() -> Int { return self.satFat}
    public func getCholesterol() -> Int { return self.cholesterol}
    public func getSodium() -> Int { return self.sodium}
    public func getPotassium() -> Int { return self.potassium}
    public func getCarbs() -> Int { return self.carbs}
    public func getFiber() -> Int { return self.fiber}
    public func getSugar() -> Int { return self.sugar}
    public func getComments() -> [Comment] { return self.comments}
    public func getIngredients() -> [(id:Int,ing:Ingredient, amount:Float)] { return self.ingredients}
    public func getDirections() -> [String] { return self.directions}
    public func getRating() -> Int { return self.rating}
    public func getFlags() -> Int{ return self.flags}
    public func getVitamins() -> [Vitamin] { return self.vitamin}
}