//
//  GameViewController.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 15/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lirikText: UITextView!
    @IBOutlet weak var rondeLabel: UILabel!
    @IBOutlet weak var playerTable: UITableView!
    
    
    let mc = MCHandler.shared
    let game = GameHandler.shared
        
    let cellReuseIdentifier = "playerCellID"
    let cellSpacingHeight: CGFloat = 0
    
    var roundNow = 0
    let sing = AVSpeechSynthesizer()
    
    var lyricNow = 0
    var songNow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sing.delegate = self
        
        singSong(songId: 0)
    }
    
    func singSong(songId: Int) {
        singThis(gameData.listOfSongs[songId].lirik[lyricNow])
    }
    
    func singThis(_ phrase: String){
        lirikText.text = "\(lirikText.text ?? "") \n\(phrase)"
        
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        sing.speak(utterance)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onFinishSing(_:)), name: .finishSing, object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return gameData.listOfPlayers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "playersCellID", for: indexPath) as? PlayerCell)!
        
    //        cell.playerName.text = listofPlayer[indexPath.section].name
        cell.playerName.text = gameData.listOfPlayers[indexPath.section].name
    //        cell.playerName.text = gameData.listOfSongs[indexPath.section].judul
    //        cell.playerStatus.text = "\(listofPlayer[indexPath.section].points)"
        cell.playerStatus.text = "\(gameData.listOfPlayers[indexPath.section].points)"
    //        cell.playerImage.image = chars[listofPlayer[indexPath.section].char]
        cell.playerImage.image = chars[gameData.listOfPlayers[indexPath.section].char]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @IBAction func shakeButton(_ sender: Any) {
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    @objc func onFinishSing(_ notification:Notification){
        DispatchQueue.main.async {
            guard let lyricId = notification.object as? Int else {return}
            if lyricId < 4 {
                self.singThis(gameData.listOfSongs[self.songNow].lirik[lyricId])
            } else {
                self.songNow += 1
                self.lyricNow = 0
            }
        }
    }
}


// finish sing
extension GameViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        lyricNow += 1
        NotificationCenter.default.post(name: .finishSing, object: lyricNow)
    }
}
