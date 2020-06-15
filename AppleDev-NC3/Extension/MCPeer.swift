//
//  MCPeer.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 14/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class MCPeer: MCPeerID {
    var char:Int = Int()
    var point:Int = Int()
    
    override init(displayName myDisplayName: String) {
        super.init(displayName: myDisplayName)
        setData(0, 0)
    }
    
    func setChar(_ char:Int){
        self.char = char
    }
    
    func setPoint(_ point:Int){
        self.point = point
    }
    
    func setData(_ char:Int,_ point:Int) {
        setPoint(point)
        setChar(char)
    }
    
    func getPoint() -> Int {
        return point
    }
    
    func getChar() -> Int {
        return char
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
