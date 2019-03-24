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
    var emojiArt: L14EmojiArt?
    
    var thumbnail: UIImage?  // 这个文档的缩略图
    
    override func contents(forType typeName: String) throws -> Any {
        return emojiArt?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            emojiArt = L14EmojiArt(json: json)
        }
    }
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        if let thumbnail = self.thumbnail {
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey: thumbnail]
        }
        return attributes
    }
}

