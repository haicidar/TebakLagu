//
//  GameViewController.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 15/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import UIKit
import AVFoundation

enum Counter{
    case ready, main
}

var songNow = 0
class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lirikText: UITextView!
    @IBOutlet weak var rondeLabel: UILabel!
    @IBOutlet weak var playerTable: UITableView!
    
    
    let mc = MCHandler.shared
    let game = GameHandler.shared
        
    let cellReuseIdentifier = "playerCellID"
    let cellSpacingHeight: CGFloat = 0
    
//    var roundNow = 0
    let sing = AVSpeechSynthesizer()
    
    var lyricNow = 0
    var isFinishSing = false
    
    var ready = 3
    var second = 32
    var timer = Timer()
    var timerGantiPage = Timer()
    var timerIsOn = false
    
    let trackLayer = CAShapeLayer()
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sing.delegate = self

        setupTimeProgress()
        startRound(round: songNow)
        
    }
    
    func setupTimeProgress() {
        
        let roundedPath = UIBezierPath(roundedRect: CGRect(x: -185, y: -330, width: 370, height: 245), byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: 25.0, height: 25.0))
           
        trackLayer.path = roundedPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 15
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.position = CGPoint(x: view.center.x, y: view.center.y)
           
        view.layer.addSublayer(trackLayer)
           
        shapeLayer.path = roundedPath.cgPath
        shapeLayer.strokeColor = UIColor.systemGreen.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.position = CGPoint(x: view.center.x, y: view.center.y)
        shapeLayer.strokeColor = #colorLiteral(red: 0.8078431373, green: 0.9215686275, blue: 0.6470588235, alpha: 1)
        shapeLayer.strokeEnd = 1
        
        view.layer.addSublayer(shapeLayer)
    }
       
    func beginTimer(_ type:Counter){
        timer.invalidate()
        switch type {
        case .ready:
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateReady), userInfo: nil, repeats: true)
        case .main:
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    func startRound(round:Int){
        if round == gameData.rounds{
            print("finish")
        }
        second = 32
        ready = 3
        beginTimer(.ready)
    }
    
    @objc func updateReady(){
        lirikText.text = "\(ready)"
        ready -= 1
        if ready == 0 {
            timer.invalidate()
            lirikText.text = ""
            beginTimer(.main)
            singSong(songId: songNow)
        }
    }
       
    @objc func updateTimer(){
        second -= 1
        let percentage = Float(second)/32
        shapeLayer.strokeEnd = CGFloat(percentage)
        
        if isFinishSing {
            singSong(songId: songNow)
        }
        
        if second == 10 {
            shapeLayer.strokeColor = #colorLiteral(red: 0.8901960784, green: 0.662745098, blue: 0.662745098, alpha: 1)
        }
        
        if second == 0 {
            timer.invalidate()
            rondeLabel.text = "Ronde \(songNow+1)"
            print("coba nyanyi lagu ke \(songNow)")
            startRound(round: songNow)
        }
    }
    
    @objc func singSong(songId: Int) {
        if lyricNow == ((32 - second)/8){
            singThis(gameData.listOfSongs[songId].lirik[lyricNow])
        }
    }
    
    func singThis(_ phrase: String){
        isFinishSing = false
        lirikText.text = "\(lirikText.text ?? "") \n\(phrase)"
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        utterance.rate = 0.3
        sing.speak(utterance)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerTable.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(onFinishSing(_:)), name: .finishSing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backToGame(_:)), name: .dismissedModal, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(waitModal), name: .didAnswer, object: nil)
    }
    
    @objc func backToGame(_ notification:Notification){
        beginTimer(.main)
    }
    
    @objc func waitModal(_ notification:Notification){
        timer.invalidate()
        guard let data = notification.object as? UUID else{return}
        answerId = data
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Modal", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Modal")
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.present(nextViewController, animated:true, completion:nil)
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
        timer.invalidate()
        answerId = myId
        let dataId = try! JSONEncoder().encode(myId)
        do {
            try self.mc.session.send(dataId, toPeers: self.mc.session.connectedPeers, with: .reliable)
          }catch let error {
            print(error.localizedDescription)
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Modal", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Answer")
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @objc func onFinishSing(_ notification:Notification){
        DispatchQueue.main.async {
            guard let lyricId = notification.object as? Int else {return}
            if lyricId < 4 {
                self.singSong(songId: songNow)
            } else {
                songNow += 1
                self.lyricNow = 0
            }
        }
    }
}


// finish sing
extension GameViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        lyricNow += 1
        isFinishSing = true
        NotificationCenter.default.post(name: .finishSing, object: lyricNow)
    }
}
