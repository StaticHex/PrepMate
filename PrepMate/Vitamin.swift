//
//  Vitamin.swift
//  PrepMate
//
//  Created by Yen Chen Wee on 3/27/18.
//  Copyright © 2018 Joseph Bourque. All rights reserved.
//

import Foundation
class Vitamin {
    private var id:Int
    private var index:Int
    private var percent:Float
    init(id:Int, index:Int, percent:Float){
        self.id = id
        self.index = index
        self.percent = percent
    }
    func getId() -> Int {return self.id}
    func getIndex() -> Int{return self.index}
    func getPercent() -> Float{return self.percent}
}
