//
//  ModalViewController.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 15/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import UIKit
import MultipeerConnectivity

var answerId:UUID!

class ModalViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var modalImage: UIImageView!
    @IBOutlet weak var modalLabel: UILabel!
    @IBOutlet weak var modalDesc: UILabel!
    
    var nowAnswerId:UUID!
    let mc = MCHandler.shared
    var playerId = 0
    
    override func viewDidLoad() {
          super.viewDidLoad()
          view.backgroundColor = UIColor(white: 0, alpha: 0.6)
          view.isOpaque = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkModal(_:)), name: .didAnswer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkAnswer(_:)), name: .checkAnswer, object: nil)
        
        if answerId == myId {
            self.modalImage.image = UIImage(named: "false")
            self.titleLabel.text = "Jawaban Kamu"
            self.modalLabel.text = "Gagal!"
            self.modalDesc.text = "Kamu gagal menjawab"
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissModal))
            view.addGestureRecognizer(tap)
        }
        
        if answerId != myId && answerId != nowAnswerId {
            playerId = gameData.listOfPlayers.firstIndex(where: {$0.id == answerId})!
            self.modalImage.image = chars[gameData.listOfPlayers[playerId].char]
            self.modalLabel.text = "Tunggu Ya!"
            self.modalDesc.text = "\(gameData.listOfPlayers[playerId].name) sedang menjawab"
            self.titleLabel.text = "\(gameData.listOfPlayers[playerId].name) Menjawab"
            nowAnswerId = answerId
        }
      }
    

    @objc func dismissModal(){
        answerId = nil
        let data = try! JSONEncoder().encode(dataType.dimsiss)
        do {
            try self.mc.session.send(data, toPeers: self.mc.session.connectedPeers, with: .reliable)
          }catch let error {
            print(error.localizedDescription)
        }
        NotificationCenter.default.post(name: .dismissedModal, object: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    
    @objc func checkAnswer(_ notification:Notification){
        if let data = notification.object as? dataType{
            switch data {
            case .correct:
                self.modalImage.image = UIImage(named: "true")
                self.modalLabel.text = "Benar!"
                self.modalDesc.text = "Kamu Benar!"
                break
            case .wrong:
                self.modalImage.image = UIImage(named: "false")
                self.modalLabel.text = "Gagal!"
                self.modalDesc.text = "Kamu gagal menjawab"
                break
            case .dimsiss:
                break
            }
        }
    }
    
    //Function for dismiss the Hint
      @objc func checkModal(_ notification:Notification){
        DispatchQueue.main.async {
            if let data = notification.object as? dataType{
                switch data{
                case .correct:
                    self.modalImage.image = UIImage(named: "true")
                    self.modalLabel.text = "Benar!"
                    self.modalDesc.text = "\(gameData.listOfPlayers[self.playerId].name) Benar!"
                    gameData.listOfPlayers[self.playerId].points += 10
                    break
                case .wrong:
                    self.modalImage.image = UIImage(named: "false")
                    self.modalLabel.text = "Gagal!"
                    self.modalDesc.text = "\(gameData.listOfPlayers[self.playerId].name) gagal menjawab"
                    break
                case .dimsiss:
                    NotificationCenter.default.post(name: .dismissedModal, object: nil)
                    self.dismiss(animated: true, completion: nil)
                    break
                }
            }
        }
    }
}
