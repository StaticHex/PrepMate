//
//  Vitamin.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation
class Vitamin {
    public var id:Int
    public var index:Int
    public var percent:Float
    init(id:Int, index:Int, percent:Float){
        self.id = id
        self.index = index
        self.percent = percent
    }
}
