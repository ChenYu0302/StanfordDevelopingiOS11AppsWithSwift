//
//  Lecture08PlayingCardDeck.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/11.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

struct L08PlayingCardDeck
{
    private(set) var cards = [L08PlayingCard]()
    
    init() {
        for suit in L08PlayingCard.Suit.all {
            for rank in L08PlayingCard.Rank.all {
                cards.append(L08PlayingCard(suit: suit, rank:rank))
            }
        }
    }
    
    mutating func draw() -> L08PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
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
