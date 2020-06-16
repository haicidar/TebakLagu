//
//  LobbyViewController.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 14/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AVFoundation

class LobbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MCNearbyServiceAdvertiserDelegate {
        
    @IBOutlet weak var hostName: UILabel!
    @IBOutlet weak var hostChar: UIImageView!
    
    @IBOutlet weak var tablePlayers: UITableView!
    
    
    @IBOutlet weak var buttonMulai: UIButton!
    
    var BGM = AVAudioPlayer()
    var advertiser: MCNearbyServiceAdvertiser!
    let mc = MCHandler.shared
    let game = GameHandler.shared
        
    let cellReuseIdentifier = "playerCellID"
    let cellSpacingHeight: CGFloat = 0
        
//    var listofPlayer: [Player] = []

    override func viewDidLoad() {
        super.viewDidLoad()
            
        buttonMulai.layer.cornerRadius = 25
        buttonMulai.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        buttonMulai.layer.borderWidth = 3.0
        buttonMulai.isHidden = true
        buttonMulai.backgroundColor = nil
        
        
        do{
            let BGMPath = Bundle.main.path(forResource: "bgm2", ofType: "mp3")
            try BGM = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: BGMPath!) as URL)
        } catch {
            // error
        }
        
        BGM.numberOfLoops = -1
        BGM.volume = 0.3
        BGM.prepareToPlay()
        BGM.play()
        
        
//        you
        hostChar.image = chars[mc.playerData.char]
        hostName.text = "\(mc.playerData.name)"
        
        if mc.isHost{
            buttonMulai.isHidden = false
            buttonMulai.backgroundColor = #colorLiteral(red: 0.9652885795, green: 0.8426560163, blue: 0.498026967, alpha: 1)
            
            gameData.listOfPlayers.append(Player(name: mc.playerData.name, char: mc.playerData.char, points: mc.playerData.points))
            
            advertiser = MCNearbyServiceAdvertiser(peer: mc.peerID, discoveryInfo: nil, serviceType: "game")
            advertiser.delegate = self
            advertiser.startAdvertisingPeer()
        } else {
            let data = mc.playerData
            let jsonData = try! JSONEncoder().encode(data)
            do {
                try mc.session.send(jsonData, toPeers: mc.session.connectedPeers, with: .reliable)
            }catch{
                fatalError("Could not send data")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onConnected(_:)), name: .statusConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDisconnected(_:)), name: .statusDisconnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onHostLeft(_:)), name: .hostLeft, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        if isMovingFromParent{
            if mc.isHost{
                advertiser.stopAdvertisingPeer()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return listofPlayer.count
        return mc.session.connectedPeers.count
//        return gameData.listOfSongs.count
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "playerCellID", for: indexPath) as? PlayerCell)!
        
//        cell.playerName.text = listofPlayer[indexPath.section].name
        cell.playerName.text = mc.session.connectedPeers[indexPath.section].displayName
//        cell.playerName.text = gameData.listOfSongs[indexPath.section].judul
//        cell.playerStatus.text = "\(listofPlayer[indexPath.section].points)"
        cell.playerStatus.text = "Ready"
//        cell.playerImage.image = chars[listofPlayer[indexPath.section].char]
        cell.playerImage.image = chars[0]
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    @IBAction func start(_ sender: Any) {
        BGM.stop()
        //host send update data
        let datas = gameData
        NotificationCenter.default.post(name: .didReceiveData, object: datas)
        let jsonData = try! JSONEncoder().encode(datas)
        do {
            try self.mc.session.send(jsonData, toPeers: self.mc.session.connectedPeers, with: .reliable)
        }catch{
            fatalError("Could not send data")
        }
        advertiser.stopAdvertisingPeer()
        self.performSegue(withIdentifier: "lobbyToGame", sender: self)
    }
    
    
    @objc func onDidReceiveData(_ notification:Notification) {
        DispatchQueue.main.async {
            if self.mc.isHost{
                //host receive and update
                guard let data = notification.object as? Player else{return}
                gameData.listOfPlayers.append(data)
            } else {
                self.BGM.stop()
                guard let datas = notification.object as? GameData else{return}
                gameData = datas
                self.performSegue(withIdentifier: "lobbyToGame", sender: self)
            }
            self.tablePlayers.reloadData()
        }
    }
    
    @objc func onConnected(_ notification:Notification) {
        DispatchQueue.main.async {
            if self.mc.isHost && self.mc.session.connectedPeers.count>0{
                self.buttonMulai.isEnabled = true
                print("masukenable1")
            }
            else{
                self.buttonMulai.isEnabled = false
                print("masukdisable1")
            }
            self.tablePlayers.reloadData()
        }
    }
    
    @objc func onDisconnected(_ notification:Notification) {
        DispatchQueue.main.async {
            if self.mc.isHost && self.mc.session.connectedPeers.count>0{
                self.buttonMulai.isEnabled = true
                print("masukenable2")
            }
            else{
                self.buttonMulai.isEnabled = false
                print("masukdisable2")
            }
            self.tablePlayers.reloadData()
        }
    }
    
    @objc func onHostLeft(_ notification:Notification) {
        DispatchQueue.main.async {
            guard var viewControllers = self.navigationController?.viewControllers else { return }
            
            _ = viewControllers.popLast()
            
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true,mc.session)
    }
}
