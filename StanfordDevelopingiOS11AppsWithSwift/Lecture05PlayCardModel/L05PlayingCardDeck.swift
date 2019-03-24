//
//  Lecture05PlayingCardDeck.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/7.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation


/// 模型：一副扑克牌
struct L05PlayingCardDeck
{
    private(set) var cards = [L05PlayingCard]()
    
    init() {
        for suit in L05PlayingCard.Suit.all {
            for rank in L05PlayingCard.Rank.all {
                cards.append(L05PlayingCard(suit: suit, rank:rank))
            }
        }
    }
    
    
    /// 从一副扑克牌抽出一张卡牌
    ///
    /// - Returns: 抽出的卡牌
    mutating func draw() -> L05PlayingCard? {
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


