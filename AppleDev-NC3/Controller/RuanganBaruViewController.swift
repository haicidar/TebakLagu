//
//  RuanganBaruViewController.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 15/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import UIKit

class RuanganBaruViewController: UIViewController {
    var rounds = 1
    @IBOutlet var stepper: [UIButton]!
    @IBOutlet weak var roundsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        view.isOpaque = false
        
        }
    
    @IBAction func roundsStepper(_ sender: UIButton) {
        if sender.tag == 0{
            rounds -= 2
        } else {
            rounds += 2
        }
        
        if rounds < 2 {
            stepper[0].isEnabled = false
        } else if rounds > 6 {
            stepper[1].isEnabled = false
        } else {
            stepper[0].isEnabled = true
            stepper[1].isEnabled = true
        }
        roundsLabel.text = "\(rounds)"
    }
    
    @IBAction func create(_ sender: Any) {
        gameData.rounds = rounds
        gameData.randomSongs(rounds: rounds, cat: .all)
        
        //perform segue
        performSegue(withIdentifier: "createToLobby", sender: self)
    }
}
