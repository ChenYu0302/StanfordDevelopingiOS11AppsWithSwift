//
//  Lecture03ViewController.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/1.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class Lecture03ViewController: UIViewController {
    
    private lazy var game = Lecture03Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards:Int {
        return (cardButtons.count + 1) / 2
    }
    
    
    private(set) var flipCount = 0 { didSet{ self.flipCountLabel.text = "Flips: \(flipCount)" } }
    
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        
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
    
    
    private func updateViewFromModel() {
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
    
    
    private var emojiChoice:[String] = ["😈","🦇","🎃","👻","🙀","😱","🍎","🍬","🍭","🕷"]
    
    private var emoji:[Int: String] = [:]
    
    private func emoji(for card:Lecture03Card) -> String {
        
        if emoji[card.identifier] == nil, emojiChoice.count > 0 {
            emoji[card.identifier] = emojiChoice.remove(at: emojiChoice.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
    }
}

extension Int {
    var arc4random:Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
}

