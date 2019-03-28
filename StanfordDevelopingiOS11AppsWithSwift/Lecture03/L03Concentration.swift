//
//  Lecture03Concentration.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/1.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

class L03Concentration {
    
    private(set) var cards:[L03Card] = []
    
    private var IndexOfOneAndOnlyFaceUpCard: Int?{
        get {
            var foundIndex:Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil{
                        foundIndex = index // 一张卡朝上
                    }else {
                        return nil // 两张卡朝上
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Lecture03Concentration.chooseCard(at: \(index): chosen index is not in the cards")
        if !cards[index].isMatched {
            if let intexTomatch = IndexOfOneAndOnlyFaceUpCard, intexTomatch != index {
                cards[index].isFaceUp = true
                if cards[index].identifier == cards[intexTomatch].identifier {
                    cards[index].isMatched = true
                    cards[intexTomatch].isMatched = true
                } else {
                    cards[index].isMatched = false
                    cards[intexTomatch].isMatched = false
                }
            } else {
                IndexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Lecture03Concentration.init(numberOfPairsOfCards: \(numberOfPairsOfCards): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = L03Card()
            cards += [card,card]
        }
    }
    
}



