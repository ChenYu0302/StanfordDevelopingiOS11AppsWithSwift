//
//  Lecture07Card.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/10.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

struct L07Card: Hashable
{
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    
    var hashValue: Int {return self.identifier}
    
    static func == (lhs: L07Card, rhs: L07Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        L07Card.identifierFactory += 1
        return L07Card.identifierFactory
    }
    
    init() {
        self.identifier = L07Card.getUniqueIdentifier()
    }
}

