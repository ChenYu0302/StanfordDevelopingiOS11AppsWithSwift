//
//  Lecture10ConcentrationViewController.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/12.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class L10ConcentrationViewController: UIViewController {

    private lazy var game = L10Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards:Int {
        return (visibleCardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet{
            updateFlipCountLabel()
        }
    }
    
    func updateFlipCountLabel() {
        let attributes:[NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeWidth : 5.0,
            NSAttributedString.Key.strokeColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(
            string: traitCollection.verticalSizeClass == .compact ? "Flips\n\(flipCount)" : "Flips: \(flipCount)",
            attributes: attributes
        )
        self.flipCountLabel.attributedText = attributedString
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateViewFromModel()
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter { !$0.superview!.isHidden }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        
        self.flipCount += 1
        
        if let cardNumber = visibleCardButtons.firstIndex(of: sender)
        {
            print("chosen card number = \(cardNumber) ")
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("chosen card was not in visibleCardButtons")
        }
    }
    
    
    private func updateViewFromModel() {
        if visibleCardButtons != nil {
            for index in visibleCardButtons.indices {
                let button = visibleCardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for:.normal)
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                } else {
                    button.setTitle("", for: .normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0): #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                }
            }
        }
    }
    
    var theme: String? {
        didSet {
            emojiChoice = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private var emojiChoice = "😈🦇🎃👻🙀😱🍎🍬🍭🕷"
    
    private var emoji:[L10Card: String] = [:]
    
    private func emoji(for card:L10Card) -> String {
        
        if emoji[card] == nil, emojiChoice.count > 0 {
            let randomStringIndex = emojiChoice.index(emojiChoice.startIndex, offsetBy: emojiChoice.count.arc4random)
            emoji[card] = String(emojiChoice.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}




/*
 此处代码被注释，因为对 Int 的扩展不能重复
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
 */
