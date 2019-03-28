//
//  Assignment01Concentration.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/2/28.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

class A01Concentration {
    
    var flipCount = 0
    var score = 0
    var IndexOfCardHasBeenFaceUp = Set<Int>()
    var lastFlippingOneCardDate = Date()
    
    var cards:[A01Card] = []
    var gameOver = false
    
    var IndexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(in index: Int) {
        if !cards[index].isMatched {
            self.flipCount += 1
            
            if let intexTomatch = IndexOfOneAndOnlyFaceUpCard, intexTomatch != index {
                cards[index].isFaceUp = true
                self.IndexOfOneAndOnlyFaceUpCard = nil
                if cards[index].identifier == cards[intexTomatch].identifier {
                    cards[index].isMatched = true
                    cards[intexTomatch].isMatched = true
                    self.score += 2
                    let currentDate = Date()
                    if currentDate.timeIntervalSince(self.lastFlippingOneCardDate) < 0.5 {self.score += 2}
                } else {
                    cards[index].isMatched = false
                    cards[intexTomatch].isMatched = false
                    if IndexOfCardHasBeenFaceUp.contains(index) {
                        self.score -= 1
                        let currentDate = Date()
                        if currentDate.timeIntervalSince(self.lastFlippingOneCardDate) > 1 {self.score -= 1}
                    }
                }
            } else {
                for flipDownIndex in cards.indices{
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                self.IndexOfOneAndOnlyFaceUpCard = index
                self.lastFlippingOneCardDate = Date()
            }
            self.IndexOfCardHasBeenFaceUp.insert(index)
        }
        
        print(self.score)
        // 判断游戏是否结束
        for card in cards{
            if card.isMatched == false {
                return
            }
        }
        self.gameOver = true
        
    }
    
    init(numberOfPairsOfCards: Int) {
        self.cards = []
        for _ in 0..<numberOfPairsOfCards {
            let card = A01Card()
            self.cards += [card,card]
        }
        
        // 洗牌
        for _ in 0...100 {
            let randomIndex = Int.random(in: 0..<cards.count)
            let randomcard = cards[randomIndex]
            cards.remove(at: randomIndex)
            cards.append(randomcard)
        }
    }
}

