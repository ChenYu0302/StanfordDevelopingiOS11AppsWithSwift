//
//  Assignment01ViewController.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/2/28.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class A01ViewController: UIViewController {
    
    @IBOutlet var cardButtons: [UIButton]!
    lazy var game = A01Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var NewGameButton: UIButton!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender)
        {
            game.chooseCard(in: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction func touchNewGame() {
        if game.gameOver == true {
            self.game = A01Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
            let themeKeys = Array(self.emojiTheme.keys)
            self.theme = themeKeys[Int.random(in: 0..<themeKeys.count)]
            self.emojiChoice = emojiTheme[theme]!
            self.emoji = [:]
        }
        updateViewFromModel()
    }
    
    // 在此处添加emoji主题
    let emojiTheme:[String:[String]] = [
        "Halloween":["😈","🦇","🎃","👻","🙀","😱","🍎","🍬","🍭","🕷","👹","💀"],
        "Sport":["⚽️","🏀","🏓","🏐","🏸","🎾","⛷","🎱","🏈","🏉","🏒","🏏"],
        "AnimailFace":["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐷"],
        "Face":["😀","😁","🤣","😂","😄","😅","😆","😇","😉","😊","🙂","🙃"],
        "Animail":["🐃","🐂","🐄","🐪","🐫","🐘","🦏","🦍","🐅","🐆","🐊","🐐","🐏"],
        "Constellation":["♈️","♉️","♊️","♋️","♌️","♍️","♎️","♏️","♐️","♑️","♒️","♓️"],
        "Winter":["🎄","❄️","🏂","🌨","🏒","⛷","🥌","🔔","☃️","⛄️","🤶🏻","🎅🏻"]
    ]
    
    // 在此处添加颜色主题，第一个为卡片与
    let colorTheme:[String: [UIColor]] = [
        "Halloween":[#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)],
        "Sport":[#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)],
        "AnimailFace":[#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)],
        "Face":[#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)],
        "Animail":[#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)],
        "Constellation":[#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)],
        "Winter":[#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)]
    ]
    
    var theme = "Halloween"

    lazy var emojiChoice = emojiTheme[theme]!
    
    var emoji:[Int: String] = [:]
    
    func emoji(for card:A01Card) -> String {
        
        if emoji[card.identifier] == nil, emojiChoice.count > 0 {
            let randomIndex = Int.random(in: 0..<emojiChoice.count)
            emoji[card.identifier] = emojiChoice.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    func updateViewFromModel() {
        let colors = colorTheme[theme] ?? [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for:.normal)
                button.backgroundColor = colors[0]
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0): colors[0]
            }
        }
        self.view.backgroundColor = colors[1]
        self.flipCountLabel.textColor = colors[0]
        self.flipCountLabel.text = "Flips: \(self.game.flipCount)"
        self.scoreLabel.textColor = colors[0]
        self.scoreLabel.text = "Score: \(self.game.score)"
        self.NewGameButton.setTitleColor(colors[0], for: UIControl.State.normal)
    }
}
