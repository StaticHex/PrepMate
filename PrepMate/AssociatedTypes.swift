//
//  AssociatedTypes.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 4/4/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation
import UIKit

// Selections for outlet displays that users will have on their screens
public let nutritionImages = [#imageLiteral(resourceName: "f0.png"), #imageLiteral(resourceName: "f1.png"), #imageLiteral(resourceName: "f1.png"), #imageLiteral(resourceName: "f3.png"), #imageLiteral(resourceName: "f4.png"), #imageLiteral(resourceName: "f5.png"), #imageLiteral(resourceName: "f6.png"), #imageLiteral(resourceName: "f7.png"), #imageLiteral(resourceName: "f8.png"), #imageLiteral(resourceName: "f9.png"), #imageLiteral(resourceName: "f10.png"), #imageLiteral(resourceName: "f11.png"), #imageLiteral(resourceName: "f12.png"), #imageLiteral(resourceName: "f13.png"), #imageLiteral(resourceName: "f14.png"), #imageLiteral(resourceName: "f15.png"), #imageLiteral(resourceName: "f16.png"), #imageLiteral(resourceName: "f17.png")]
public let RatingImages = [#imageLiteral(resourceName: "r0.png"), #imageLiteral(resourceName: "r1.png"), #imageLiteral(resourceName: "r2.png"), #imageLiteral(resourceName: "r3.png"), #imageLiteral(resourceName: "r4.png"), #imageLiteral(resourceName: "r5.png"), #imageLiteral(resourceName: "r6.png"), #imageLiteral(resourceName: "r7.png"), #imageLiteral(resourceName: "r8.png"), #imageLiteral(resourceName: "r9.png"), #imageLiteral(resourceName: "r10.png")]
public let categoryImages = [#imageLiteral(resourceName: "c0.png"),#imageLiteral(resourceName: "c1.png"),#imageLiteral(resourceName: "c2.png"),#imageLiteral(resourceName: "c3.png"),#imageLiteral(resourceName: "c4.png"),#imageLiteral(resourceName: "c5.png"),#imageLiteral(resourceName: "c6.png"),#imageLiteral(resourceName: "c7.png"),#imageLiteral(resourceName: "c8.png"),#imageLiteral(resourceName: "c9.png"),#imageLiteral(resourceName: "c10.png"),#imageLiteral(resourceName: "c11.png"),#imageLiteral(resourceName: "c12.png"),#imageLiteral(resourceName: "c13.png"),#imageLiteral(resourceName: "c14.png"),#imageLiteral(resourceName: "c15.png"),#imageLiteral(resourceName: "c16.png"),#imageLiteral(resourceName: "c17.png"),#imageLiteral(resourceName: "c18.png"),#imageLiteral(resourceName: "c19.png"),#imageLiteral(resourceName: "c20.png"),
                             #imageLiteral(resourceName: "c21.png"),#imageLiteral(resourceName: "c22.png"),#imageLiteral(resourceName: "c23.png"),#imageLiteral(resourceName: "c24.png"),#imageLiteral(resourceName: "c25.png"),#imageLiteral(resourceName: "c26.png"),#imageLiteral(resourceName: "c27.png"),#imageLiteral(resourceName: "c28.png"),#imageLiteral(resourceName: "c29.png"),#imageLiteral(resourceName: "c30.png"),#imageLiteral(resourceName: "c31.png"),#imageLiteral(resourceName: "c32.png"),#imageLiteral(resourceName: "c33.png"),#imageLiteral(resourceName: "c34.png"),#imageLiteral(resourceName: "c35.png"),#imageLiteral(resourceName: "c36.png"),#imageLiteral(resourceName: "c37.png"),#imageLiteral(resourceName: "c38.png"),#imageLiteral(resourceName: "c39.png"),#imageLiteral(resourceName: "c40.png"),#imageLiteral(resourceName: "c41.png"),
                             #imageLiteral(resourceName: "c42.png"),#imageLiteral(resourceName: "c43.png"),#imageLiteral(resourceName: "c44.png"),#imageLiteral(resourceName: "c45.png"),#imageLiteral(resourceName: "c46.png"),#imageLiteral(resourceName: "c47.png")]
public let vitaminList = ["Vitamin A", "Calcium", "Vitamin B-12", "Vitamin C", "Iron", "Vitamin B-6", "Magnesium"]

public let categoryList = ["African",
                           "American",
                           "Argentine",
                           "Bangladeshi",
                           "Brazilian",
                           "Burmese",
                           "Canadian",
                           "Chilean",
                           "Chinese",
                           "Ecuadorian",
                           "English",
                           "Ethiopian",
                           "French",
                           "German",
                           "Greek",
                           "Hungarian",
                           "Indian",
                           "Indonesian",
                           "Irish",
                           "Israeli",
                           "Italian",
                           "Jamaican",
                           "Japanese",
                           "Korean",
                           "North Korean",
                           "Malaysian",
                           "Maltese",
                           "Mexican",
                           "Moroccan",
                           "Nepalese",
                           "Pakistani",
                           "Palestinian",
                           "Peruvian",
                           "Philippine",
                           "Polish",
                           "Portuguese",
                           "Russian",
                           "Sami",
                           "Scottish",
                           "Sicilian",
                           "Singaporean",
                           "South African",
                           "Spanish",
                           "Sri Lankan",
                           "Thai",
                           "Tibetan",
                           "Uzbek",
                           "Vietnamese"]

public let ingredientList = [(flag: 1, name: "Tree Nuts"),
                             (flag: 2, name: "Eggs"),
                             (flag: 4, name: "Milk"),
                             (flag: 8, name: "Gluten"),
                             (flag: 16, name: "Meat"),
                             (flag: 32, name: "Pork"),
                             (flag: 64, name: "Butter"),
                             (flag: 128, name: "Peanuts"),
                             (flag: 256, name: "Shellfish"),
                             (flag: 512, name: "Tomatoes"),
                             (flag: 1024, name: "Soy"),
                             (flag: 2048, name: "Fish"),
                             (flag: 4096, name: "Yeast")]

public let foodTypeList = [(flag: 8192, name: "Spicy"),
                           (flag: 16384, name: "Healthy"),
                           (flag: 32768, name: "High Fat"),
                           (flag: 65536, name: "Vegan"),
                           (flag: 131072, name: "Vegetarian")]

// divide metric amount by factor to get standard amount
public let unitList = [(std: "custom", metric: "custom", factor: 1.0),
                        (std: "tsp", metric: "ml", factor: 5.0),
                        (std: "tbsp", metric: "ml", factor: 15.0),
                        (std: "fl oz", metric: "ml", factor: 30.0),
                        (std: "cup", metric: "ml", factor: 240.0),
                        (std: "pint", metric: "ml", factor: 480.0),
                        (std: "quart", metric: "ml", factor: 960.0),
                        (std: "oz", metric: "g", factor: 30.0),
                        (std: "lb", metric: "g", factor: 480.0),
                        (std: "in", metric: "cm", factor: 2.5)]


public func metricToStd(unit:Int, amount:Double) -> Double {
    return amount / unitList[unit].factor
}

public func stdToMetric(unit:Int, amount:Double) -> Double {
    return amount * unitList[unit].factor
}
public func getTimestamp() -> String {
    let date = Date()
    let calendar = Calendar.current
    var tsString = ""
    tsString += calendar.component(.month, from: date).description + "/"
    tsString += calendar.component(.day, from: date).description + "/"
    tsString += calendar.component(.year, from: date).description + " "
    var hour = Int(calendar.component(.hour, from: date).description)!
    var suffix = "AM"
    if(hour > 11) {
        suffix = "PM"
    }
    if(hour > 12) {
        hour -= 12
    }
    if(hour == 0) {
        hour = 12
    }
    tsString += String(hour) + ":"
    tsString += calendar.component(.minute, from: date).description+suffix
    return tsString
}

var currentUser = User()
