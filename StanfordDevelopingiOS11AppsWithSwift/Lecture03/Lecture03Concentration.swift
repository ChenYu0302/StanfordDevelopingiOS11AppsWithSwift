//
//  Lecture03Concentration.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/1.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

class Lecture03Concentration {
    
    var cards:[Lecture03Card] = []
    
    var IndexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(in index: Int) {
        if !cards[index].isMatched {
            if let intexTomatch = IndexOfOneAndOnlyFaceUpCard, intexTomatch != index {
                cards[index].isFaceUp = true
                self.IndexOfOneAndOnlyFaceUpCard = nil
                if cards[index].identifier == cards[intexTomatch].identifier {
                    cards[index].isMatched = true
                    cards[intexTomatch].isMatched = true
                } else {
                    cards[index].isMatched = false
                    cards[intexTomatch].isMatched = false
                }
            } else {
                for flipDownIndex in cards.indices{
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                IndexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Lecture03Card()
            cards += [card,card]
        }
    }
    
}



