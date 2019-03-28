//
//  Document.swift
//  DocumentBase
//
//  Created by 陈宇 on 2019/3/19.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class L14EmojiArtDocument: UIDocument
{
    var emojiArt: L14EmojiArt? // 这个文档的模型
    
    var thumbnail: UIImage?  // 这个文档的缩略图
    
    // 将这个模型转换为 JSON 文件
    // 返回值是 Any 对象（不是 Data 对象）
    // 因为他允许作为一个 FileWrapper
    // if an application would rather represent its documents that way 如果一个应用程序可以
    // 那么实参 forType: 是一个 UTI（例如 "public.json" 或 "edu.stanford.cs193p.emojiart"）
    
    override func contents(forType typeName: String) throws -> Any {
        return emojiArt?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            emojiArt = L14EmojiArt(json: json)
        }
    }
    
    // 重写以添加一个键值对到 UIDocument 写入的文件上的 "file attributes" 字典
    // 添加的键值对用于设置 UIDocument 类型的截图
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        if let thumbnail = self.thumbnail {
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey: thumbnail]
        }
        return attributes
    }
}

