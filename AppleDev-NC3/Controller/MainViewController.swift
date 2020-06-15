//
//  ViewController.swift
//  AppleDev-NC3
//
//  Created by Muhammad Haidar Rais on 12/06/20.
//  Copyright © 2020 Group-1. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData

var myName = ""
var myChar = 0
var gameData = GameData(rounds: 0)


class MainViewController: UIViewController, MCBrowserViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var charName: UITextField!
    @IBOutlet weak var charImage: UIImageView!
    @IBOutlet var charStepper: [UIButton]!
    var points = 0
    
    let mc = MCHandler.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        charName.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
//        set button char
        for stepper in charStepper {
            stepper.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            stepper.layer.borderWidth = 3.0
            stepper.layer.cornerRadius = 25
        }
//        set textfield
        charName.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        charName.layer.borderWidth = 3.0
        charName.layer.cornerRadius = 5
        
//        set char
        charImage.image = chars[0]
    }
    @IBAction func koro(_ sender: Any) {
        myName = charName.text!
    }
    
    @IBAction func aye(_ sender: Any) {
        charName.resignFirstResponder()
    }
    //03 textfield func for the return key
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
      charName.resignFirstResponder()
      return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        charName.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBAction func changeChar(_ sender: UIButton) {
        let max = chars.count
        // - char
        if sender.tag == 0{
            if myChar == 0 {
                myChar = max-1
            } else {
                myChar -= 1
            }
        // + char
        }else{
            if myChar == max-1 {
                myChar = 0
            } else {
                myChar += 1
            }
        }
        print(myChar)
        charImage.image = chars[myChar]
    }
    
    @IBAction func toRoom(_ sender: UIButton) {
        mc.playerData = Player(name: myName, char: myChar, points: 0)
        if sender.tag == 0 {

            mc.isHost = true
            mc.host = mc.peerID
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RuanganBaru")
            nextViewController.modalPresentationStyle = .overCurrentContext
            self.present(nextViewController, animated:true, completion:nil)
        }else{
            mc.isHost = false
            let mcBrowser = MCBrowserViewController(serviceType: "game", session: mc.session)
            mcBrowser.delegate = self
            present(mcBrowser, animated: true)
        }
    }
    
    func fetchMe(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
//        let fetchRequest = NSFetchRequest<Me>(entityName: "Me")
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "mainToLobby", sender: self)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
        self.mc.session.disconnect()
    }
}

