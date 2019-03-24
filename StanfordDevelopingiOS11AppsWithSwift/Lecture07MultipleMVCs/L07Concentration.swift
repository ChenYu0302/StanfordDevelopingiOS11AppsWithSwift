//
//  Lecture07Concentration.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/10.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

struct L07Concentration {
    
    private(set) var cards:[L07Card] = []
    
    private var IndexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Lecture07Concentration.chooseCard(at: \(index): chosen index is not in the cards")
        if !cards[index].isMatched {
            if let intexTomatch = IndexOfOneAndOnlyFaceUpCard, intexTomatch != index {
                if cards[index] == cards[intexTomatch] {
                    cards[index].isMatched = true
                    cards[intexTomatch].isMatched = true
                } else {
                    cards[index].isMatched = false
                    cards[intexTomatch].isMatched = false
                }
                cards[index].isFaceUp = true
            } else {
                IndexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Lecture07Concentration.init(numberOfPairsOfCards: \(numberOfPairsOfCards): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = L07Card()
            cards += [card,card]
        }
    }
}

/*
 此处代码被注释，因为对 Collection 的扩展不能重复
extension Collection {
    var oneAndOnly :Element? {
        return self.count == 1 ? first : nil
    }
}
*/
