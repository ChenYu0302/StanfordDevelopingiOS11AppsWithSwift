//
//  Lecture03Card.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/1.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

struct L03Card {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        L03Card.identifierFactory += 1
        return L03Card.identifierFactory
    }
    
    init() {
        self.identifier = L03Card.getUniqueIdentifier()
    }
    
    
}

