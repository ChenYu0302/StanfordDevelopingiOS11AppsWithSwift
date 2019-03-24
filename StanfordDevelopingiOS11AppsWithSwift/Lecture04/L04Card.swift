//
//  Lecture04Card.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/1.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation


/// 牌
struct L04Card: Hashable
{
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    
    var hashValue: Int {return self.identifier}
    
    static func == (lhs: L04Card, rhs: L04Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        L04Card.identifierFactory += 1
        return L04Card.identifierFactory
    }
    
    init() {
        self.identifier = L04Card.getUniqueIdentifier()
    }
}

