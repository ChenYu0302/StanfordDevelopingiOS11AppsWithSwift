//
//  Lecture04Card.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/1.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

struct Lecture04Card: Hashable
{
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    
    var hashValue: Int {return self.identifier}
    
    static func == (lhs: Lecture04Card, rhs: Lecture04Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        Lecture04Card.identifierFactory += 1
        return Lecture04Card.identifierFactory
    }
    
    init() {
        self.identifier = Lecture04Card.getUniqueIdentifier()
    }
}

