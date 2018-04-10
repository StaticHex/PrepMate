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
public let vitaminList = ["Vitamin A", "Calcium", "Vitamin B-12", "Vitamin C", "Iron", "Vitamin B-6", "Magnesium"]

public let categoryList = ["African",
                           "American",
                           "Argentine",
                           "Bangladeshi",
                           "Bengali",
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

public let unitList = [(std: "custom", metric: "custom"),
                        (std: "tsp", metric: "ml"),
                        (std: "tbsp", metric: "ml"),
                        (std: "fl oz", metric: "ml"),
                        (std: "cup", metric: "ml"),
                        (std: "quart", metric: "ml"),
                        (std: "pint", metric: "ml"),
                        (std: "oz", metric: "g"),
                        (std: "lb", metric: "g"),
                        (std: "in", metric: "cm")]

