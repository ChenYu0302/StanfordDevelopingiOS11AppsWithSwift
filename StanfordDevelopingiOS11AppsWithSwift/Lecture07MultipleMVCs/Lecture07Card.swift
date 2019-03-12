//
//  Lecture07Card.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/10.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

struct Lecture07Card: Hashable
{
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    
    var hashValue: Int {return self.identifier}
    
    static func == (lhs: Lecture07Card, rhs: Lecture07Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        Lecture07Card.identifierFactory += 1
        return Lecture07Card.identifierFactory
    }
    
    init() {
        self.identifier = Lecture07Card.getUniqueIdentifier()
    }
}

