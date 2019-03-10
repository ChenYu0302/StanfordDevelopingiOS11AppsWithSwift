//
//  Lecture04Concentration.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/1.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

struct Lecture04Concentration {
    
    private(set) var cards:[Lecture04Card] = []
    
    private var IndexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
//          上面一句用于替换下面被注释的代码块
//            var foundIndex:Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil{
//                        foundIndex = index // 一张卡朝上
//                    }else {
//                        return nil // 两张卡朝上
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Lecture04Concentration.chooseCard(at: \(index): chosen index is not in the cards")
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
        assert(numberOfPairsOfCards > 0, "Lecture04Concentration.init(numberOfPairsOfCards: \(numberOfPairsOfCards): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Lecture04Card()
            cards += [card,card]
        }
    }
    
}

extension Collection {
    var oneAndOnly :Element? {
        return self.count == 1 ? first : nil
    }
}


