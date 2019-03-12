//
//  Lecture06PlayingCard.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/8.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

struct Lecture06PlayingCard: CustomStringConvertible {
    
    var description: String {return "\(suit)\(rank)"}
    
    var suit:Suit
    var rank:Rank
    
    enum Suit:String, CustomStringConvertible {
        var description: String {return self.rawValue}
        
        case spades = "♠️"
        case hearts = "♥️"
        case clubs = "♣️"
        case diamonds = "♦️"
        
        static var all = [Suit.spades, Suit.clubs, Suit.clubs, Suit.diamonds]
    }
    
    enum Rank:CustomStringConvertible {
        var description: String {
            switch self {
            case .ace: return "A"
            case .face(let kind): return kind
            case .numeric(let kind): return kind.description
            }
        }
        
        case ace
        case numeric(Int)
        case face(String)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all:[Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"), Rank.face("Q"), Rank.face("K")]
            return allRanks
        }
    }
}
