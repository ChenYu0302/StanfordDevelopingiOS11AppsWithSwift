//
//  Assignment01Card.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/2/28.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

struct A01Card {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        L02Card.identifierFactory += 1
        return L02Card.identifierFactory
    }
    
    init() {
        self.identifier = L02Card.getUniqueIdentifier()
    }
    
    
}

