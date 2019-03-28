//
//  EmojiArt.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/17.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import Foundation

// EmojiArtDocument 的模型
// 它是可编解码的（遵循 Codable 协议），因此它可以很容易地与JSON格式相互转换

struct L14EmojiArt: Codable {
    var url: URL
    var emojis = [EmojiInfo]()
    
    struct EmojiInfo: Codable {
        let x: Int
        let y: Int
        let text: String
        let size: Int
    }
    
    // 这个对象可以很容易做到可编解码
    // 则称它实现了可编解码（Codable）
    // 因为他的所有变量的数据类型是可编解码的
    // 即便不是这样，你仍然可知使他可编解码
    // 通过添加初始化h鹅编码方法
    
    // 如果你想要它的 JSON 键为其他格式
    // 你可以使用下面的d代码
//     private enum CodingKeys: String, CodingKey {
//        case url = "background_url"
//        case emojis
//     }
    
    init?(json: Data) {  // take some JSON and try to init an EmojiArt from it
        if let newValue = try? JSONDecoder().decode(L14EmojiArt.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    var json: Data? { // 以 JSON 格式返回这个 EmojiArt
        return try? JSONEncoder().encode(self)
    }
    
    
    init(url: URL, emojis:[EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
}
