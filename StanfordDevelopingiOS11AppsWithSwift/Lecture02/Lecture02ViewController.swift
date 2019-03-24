//
//  Lecture1ViewController.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/2/27.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class Lecture02ViewController: UIViewController {
    
    lazy var game = Lecture02Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    
    var flipCount = 0 { didSet{ self.flipCountLabel.text = "Flips: \(flipCount)" } }
    
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
   
    @IBAction func touchCard(_ sender: UIButton) {
        
        self.flipCount += 1
        
        if let cardNumber = cardButtons.firstIndex(of: sender)
        {
            print("chosen card number = \(cardNumber) ")
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("chosen card was not in cardButtons")
        }

    }
    
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for:.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0): #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    
    var emojiChoice:[String] = ["😈","🦇","🎃","👻","🙀","😱","🍎","🍬","🍭","🕷"]
    
    var emoji:[Int: String] = [:]
    
    func emoji(for card:Lecture02Card) -> String {
        
        if emoji[card.identifier] == nil, emojiChoice.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoice.count)))
            emoji[card.identifier] = emojiChoice.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}


