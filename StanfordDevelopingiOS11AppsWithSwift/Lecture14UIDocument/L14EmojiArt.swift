//
//  EmojiArt.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/17.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation


struct L14EmojiArt: Codable {
    var url: URL
    var emojis = [EmojiInfo]()
    
    struct EmojiInfo: Codable {
        let x: Int
        let y: Int
        let text: String
        let size: Int
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(L14EmojiArt.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    
    init(url: URL, emojis:[EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
    
    
    
}

