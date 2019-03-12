//
//  Lecture09Card.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/12.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

struct Lecture09Card: Hashable
{
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    
    var hashValue: Int {return self.identifier}
    
    static func == (lhs: Lecture09Card, rhs: Lecture09Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        Lecture09Card.identifierFactory += 1
        return Lecture09Card.identifierFactory
    }
    
    init() {
        self.identifier = Lecture09Card.getUniqueIdentifier()
    }
}

