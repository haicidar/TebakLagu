//
//  GameHandler.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 14/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import Foundation

class GameHandler{
    static let shared = GameHandler()
    let mc = MCHandler.shared
    var time = 300
    var timer:Timer?
    
    private init(){
        NotificationCenter.default.addObserver(self, selector: #selector(onHostLeft(_:)), name: .hostLeft, object: nil)
    }
    
    @objc func onHostLeft(_ notification:Notification) {
        DispatchQueue.main.async {
            self.stopGame()
        }
    }
    
    func stopGame(){
        self.timer?.invalidate()
    }
    
    func hostStartGame(){
        if !mc.isHost{
            return
        }
        time = 300
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                let data = SentData(
                    startGame: self.time == 300,
                    char: 0,
                    name: "aye",
                    time: self.time
                )
                NotificationCenter.default.post(name: .didReceiveData, object: data)
                let jsonData = try! JSONEncoder().encode(data)
                do {
                    try self.mc.session.send(jsonData, toPeers: self.mc.session.connectedPeers, with: .reliable)
                } catch let error {
                    print(error.localizedDescription)
                }
                self.time -= 1
            }
        }
    }
}
