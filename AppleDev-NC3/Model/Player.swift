//
//  Player.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 13/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import Foundation
import UIKit

var chars:[UIImage] = [#imageLiteral(resourceName: "char1"), #imageLiteral(resourceName: "char2"), #imageLiteral(resourceName: "char3"), #imageLiteral(resourceName: "char5"), #imageLiteral(resourceName: "char4"), #imageLiteral(resourceName: "char6"), #imageLiteral(resourceName: "char7")]
var category:[UIImage] = [#imageLiteral(resourceName: "all"), #imageLiteral(resourceName: "90ss"), #imageLiteral(resourceName: "is00s")]

class Player: Codable{
    var id = myId
    var name:String
    var char:Int
    var points:Int
    
    init(name:String, char:Int, points:Int) {
        self.name = name
        self.char = char
        self.points = points
    }
}
