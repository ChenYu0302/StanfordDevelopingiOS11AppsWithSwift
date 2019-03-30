//
//  Lecture13Utility.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/12.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class L14ImageFetcher
{
    // Public API
    // 公开 API
    
    // To use, create with the closure you want called when the image is ready.
    // 使用时，创建一个闭包，用于图片已经准备好时调用
    // Example: let fetcher = ImageFetcher() { // code to execute when fetch is done }
    // 例子：let fetcher = ImageFetcher() { // 当获取图片完成后你要运行的代码 }
    // Your closure is invoked OFF THE MAIN THREAD.
    // 你的闭包在主线程外被唤醒
    // Then call fetch(url:) with the url you want to fetch.
    // 然后调用 fetch(url:) ，参数 url 是你想获取的路径
    // And set a backup image in case the fetch fails.
    // 同时设置备份图片以防获取失败
    //
    // The handler will be called immediately if the fetch succeeds.
    // If the fetch fails, the handler will be called if and when the backup image is set.
    // The backup can be set at any time (i.e. before, during or after the fetch).
    // If the fetch fails and a backup image is never set, the handler will never be called.
    // Thus it would sort of be a strange use of this class to not set a backup image
    //   (because you'd never find out when the fetch failed).
    // Note that you must keep a strong pointer to this object until the fetch finishes
    //   otherwise the result of the fetch will be discarded and the handler never called.
    // In other words, keeping a strong pointer to your instance says "I'm still interested in its result."
    
    var backup: UIImage? { didSet { callHandlerIfNeeded() } }
    
    func fetch(_ url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let data = try? Data(contentsOf: url.imageURL) {
                if self != nil {
                    // yes, it's ok to create a UIImage off the main thread
                    if let image = UIImage(data: data) {
                        self?.handler(url, image)
                    } else {
                        self?.fetchFailed = true
                    }
                } else {
                    print("ImageFetcher: fetch returned but I've left the heap -- ignoring result.")
                }
            } else {
                self?.fetchFailed = true
            }
        }
    }
    
    init(handler: @escaping (URL, UIImage) -> Void) {
        self.handler = handler
    }
    
    init(fetch url: URL, handler: @escaping (URL, UIImage) -> Void) {
        self.handler = handler
        fetch(url)
    }
    
    // Private Implementation
    
    private let handler: (URL, UIImage) -> Void
    private var fetchFailed = false { didSet { callHandlerIfNeeded() } }
    private func callHandlerIfNeeded() {
        if fetchFailed, let image = backup, let url = image.storeLocallyAsJPEG(named: String(Date().timeIntervalSinceReferenceDate)) {
            handler(url, image)
        }
    }
}


// MARK: - Lecture10 Extenstion
//
//extension UIViewController {
//    var contents: UIViewController {
//        if let navcon = self as? UINavigationController {
//            return navcon.visibleViewController ?? navcon
//        } else {
//            return self
//        }
//    }
//}
//
// MARK: - Lecture11 Extenstion
//
//extension URL {
//    var imageURL: URL {
//        if let url = UIImage.urlToStoreLocallyAsJPEG(named: self.path) {
//            // this was created using UIImage.storeLocallyAsJPEG
//            return url
//        } else {
//            // check to see if there is an embedded imgurl reference
//            for query in query?.components(separatedBy: "&") ?? [] {
//                let queryComponents = query.components(separatedBy: "=")
//                if queryComponents.count == 2 {
//                    if queryComponents[0] == "imgurl", let url = URL(string: queryComponents[1].removingPercentEncoding ?? "") {
//                        return url
//                    }
//                }
//            }
//            return self.baseURL ?? self
//        }
//    }
//}
//
//extension UIImage
//{
//    private static let localImagesDirectory = "UIImage.storeLocallyAsJPEG"
//
//    static func urlToStoreLocallyAsJPEG(named: String) -> URL? {
//        var name = named
//        let pathComponents = named.components(separatedBy: "/")
//        if pathComponents.count > 1 {
//            if pathComponents[pathComponents.count-2] == localImagesDirectory {
//                name = pathComponents.last!
//            } else {
//                return nil
//            }
//        }
//        if var url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
//            url = url.appendingPathComponent(localImagesDirectory)
//            do {
//                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
//                url = url.appendingPathComponent(name)
//                if url.pathExtension != "jpg" {
//                    url = url.appendingPathExtension("jpg")
//                }
//                return url
//            } catch let error {
//                print("UIImage.urlToStoreLocallyAsJPEG \(error)")
//            }
//        }
//        return nil
//    }
//
//    func storeLocallyAsJPEG(named name: String) -> URL? {
//        if let imageData = self.jpegData(compressionQuality: 1.0) {
//            if let url = UIImage.urlToStoreLocallyAsJPEG(named: name) {
//                do {
//                    try imageData.write(to: url)
//                    return url
//                } catch let error {
//                    print("UIImage.storeLocallyAsJPEG \(error)")
//                }
//            }
//        }
//        return nil
//    }
//}
//
//
//extension String {
//    func madeUnique(withRespectTo otherStrings: [String]) -> String {
//        var possiblyUnique = self
//        var uniqueNumber = 1
//        while otherStrings.contains(possiblyUnique) {
//            possiblyUnique = self + " \(uniqueNumber)"
//            uniqueNumber += 1
//        }
//        return possiblyUnique
//    }
//}


// MARK: - Lecture12 Extenstion
//
//extension NSAttributedString {
//    func withFontScaled(by factor: CGFloat) -> NSAttributedString {
//        let mutable = NSMutableAttributedString(attributedString: self)
//        mutable.setFont(mutable.font?.scaled(by: factor))
//        return mutable
//    }
//    var font: UIFont? {
//        get { return attribute(.font, at: 0, effectiveRange: nil) as? UIFont }
//    }
//}
//
//extension NSMutableAttributedString {
//    func setFont(_ newValue: UIFont?) {
//        if newValue != nil { addAttributes([.font:newValue!], range: NSMakeRange(0, length)) }
//    }
//}
//
//extension UIFont {
//    func scaled(by factor: CGFloat) -> UIFont { return withSize(pointSize * factor) }
//}
//
//extension UILabel {
//    func stretchToFit() {
//        let oldCenter = center
//        sizeToFit()
//        center = oldCenter
//    }
//}
//
//extension CGPoint {
//    func offset(by delta: CGPoint) -> CGPoint {
//        return CGPoint(x: x + delta.x, y: y + delta.y)
//    }
//}

// MARK: - Lecture13 Extenstion
//
//extension Array where Element: Equatable {
//    var uniquified: [Element] {
//        var elements = [Element]()
//        forEach { if !elements.contains($0) { elements.append($0) } }
//        return elements
//    }
//}

// MARK: - Lecture14 Extenstion
extension String {
    func attributedString(withTextStyle style: UIFont.TextStyle, ofSize size: CGFloat) -> NSAttributedString {
        let font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(size))
        return NSAttributedString(string: self, attributes: [.font:font])
    }
}

extension UIView {
    var snapshot: UIImage? { // 视图的截图
        UIGraphicsBeginImageContext(bounds.size)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIDocument.State: CustomStringConvertible {
    public var description: String {
        return [
            UIDocument.State.normal.rawValue:".normal",
            UIDocument.State.closed.rawValue:".closed",
            UIDocument.State.inConflict.rawValue:".inConflict",
            UIDocument.State.savingError.rawValue:".savingError",
            UIDocument.State.editingDisabled.rawValue:".editingDisabled",
            UIDocument.State.progressAvailable.rawValue:".progressAvailable"
            ][rawValue] ?? String(rawValue)
    }
}
