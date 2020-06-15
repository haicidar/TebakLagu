//
//  MCHandler.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 14/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MCHandler: NSObject, MCSessionDelegate{
    static let shared = MCHandler()
    var peerID: MCPeerID!
    var playerData: Player!
    var session: MCSession!
    var isHost: Bool = false
    var host: MCPeerID?
    
    override private init(){
        super.init()
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            if (!isHost && session.connectedPeers.count == 1){
                host = peerID
            }
            NotificationCenter.default.post(name: .statusConnected, object: peerID)
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            NotificationCenter.default.post(name: .statusDisconnected, object: peerID)
            if host == peerID{
                NotificationCenter.default.post(name: .hostLeft, object: peerID)
            }
        @unknown default:
            print("Unknown")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let decoder = JSONDecoder()
        DispatchQueue.main.async {
            
            
            if self.isHost {
                //first user data join
                do {
                    let player = try decoder.decode(Player.self, from: data)
                    NotificationCenter.default.post(name: .didReceiveData, object: player)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                //update user data from host
                do {
                    let gameData = try decoder.decode(GameData.self, from: data)
                    NotificationCenter.default.post(name: .didReceiveData, object: gameData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
