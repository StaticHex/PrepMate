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

public let categoryList = [(idx: 0, name: "African"),
                           (idx: 1, name: "American"),
                           (idx: 2, name: "Argentine"),
                           (idx: 3, name: "Bangladeshi"),
                           (idx: 4, name: "Bengali"),
                           (idx: 5, name: "Brazilian"),
                           (idx: 6, name: "Burmese"),
                           (idx: 7, name: "Canadian"),
                           (idx: 8, name: "Chilean"),
                           (idx: 9, name: "Chinese"),
                           (idx: 10, name: "Ecuadorian"),
                           (idx: 11, name: "English"),
                           (idx: 12, name: "Ethiopian"),
                           (idx: 13, name: "French"),
                           (idx: 14, name: "German"),
                           (idx: 15, name: "Greek"),
                           (idx: 16, name: "Hungarian"),
                           (idx: 17, name: "Indian"),
                           (idx: 18, name: "Indonesian"),
                           (idx: 19, name: "Irish"),
                           (idx: 20, name: "Israeli"),
                           (idx: 21, name: "Italian"),
                           (idx: 22, name: "Jamaican"),
                           (idx: 23, name: "Japanese"),
                           (idx: 24, name: "Korean"),
                           (idx: 25, name: "North Korean"),
                           (idx: 26, name: "Malaysian"),
                           (idx: 27, name: "Maltese"),
                           (idx: 28, name: "Mexican"),
                           (idx: 29, name: "Moroccan"),
                           (idx: 30, name: "Nepalese"),
                           (idx: 31, name: "Pakistani"),
                           (idx: 32, name: "Palestinian"),
                           (idx: 33, name: "Peruvian"),
                           (idx: 34, name: "Philippine"),
                           (idx: 35, name: "Polish"),
                           (idx: 36, name: "Portuguese"),
                           (idx: 37, name: "Russian"),
                           (idx: 38, name: "Sami"),
                           (idx: 39, name: "Scottish"),
                           (idx: 40, name: "Sicilian"),
                           (idx: 41, name: "Singaporean"),
                           (idx: 42, name: "South African"),
                           (idx: 43, name: "Spanish"),
                           (idx: 44, name: "Sri Lankan"),
                           (idx: 45, name: "Thai"),
                           (idx: 46, name: "Tibetan"),
                           (idx: 47, name: "Uzbek"),
                           (idx: 48, name: "Vietnamese")]

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

