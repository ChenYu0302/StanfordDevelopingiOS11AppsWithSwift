//
//  Lecture10Card.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/12.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

struct L10Card: Hashable
{
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    
    var hashValue: Int {return self.identifier}
    
    static func == (lhs: L10Card, rhs: L10Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        L10Card.identifierFactory += 1
        return L10Card.identifierFactory
    }
    
    init() {
        self.identifier = L10Card.getUniqueIdentifier()
    }
}

