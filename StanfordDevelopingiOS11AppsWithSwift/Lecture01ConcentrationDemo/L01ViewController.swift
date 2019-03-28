//
//  Lecture1ViewController.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/2/27.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class L01ViewController: UIViewController {
    
    var flipCount:Int = 0{
        didSet{
            self.flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    var emojiChoice:[String] = ["🎃","👻","🎃","👻"]
    
    @IBAction func touchCard(_ sender: UIButton) {
        self.flipCount += 1
        
        if let cardNumber = cardButtons.firstIndex(of: sender)
        {
            print("cardNumber = \(cardNumber) ")
            flipCard(withEmoji: emojiChoice[cardNumber], on: sender)
        }else{
            print("chosen card was not in cardButtons")
        }
        
    }
    
    func flipCard(withEmoji emoji:String, on button:UIButton) {
        if button.currentTitle == emoji {
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }else {
            button.setTitle(emoji, for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
}
