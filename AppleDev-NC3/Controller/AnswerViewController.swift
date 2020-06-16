//
//  AnswerViewController.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 16/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    @IBOutlet weak var modalTitle: UILabel!
    @IBOutlet weak var answerText: UITextField!
    
    var mc = MCHandler.shared
    
    var answer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        view.isOpaque = false
        answerId = myId
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkAnswer(_:)), name: .checkAnswer, object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func checkAnswer(_ notification:Notification){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Modal", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Modal")
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if answerId == nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func answerField(_ sender: Any) {
        answer = answerText.text!.lowercased()
    }
    
    @IBAction func didAnswer(_ sender: Any) {
        let correctAnswer = gameData.listOfSongs[songNow].judul.lowercased()
        if answer == correctAnswer {
            let data = try! JSONEncoder().encode(dataType.correct)
            do {
                try self.mc.session.send(data, toPeers: self.mc.session.connectedPeers, with: .reliable)
              }catch let error {
                print(error.localizedDescription)
            }
        } else {
            let data = try! JSONEncoder().encode(dataType.wrong)
            do {
                try self.mc.session.send(data, toPeers: self.mc.session.connectedPeers, with: .reliable)
              }catch let error {
                print(error.localizedDescription)
            }
        }
        NotificationCenter.default.post(name: .checkAnswer, object: nil)
    }
}
