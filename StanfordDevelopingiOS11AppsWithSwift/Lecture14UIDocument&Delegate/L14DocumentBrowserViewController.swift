//
//  DocumentBrowserViewController.swift
//  DocumentBase
//
//  Created by 陈宇 on 2019/3/19.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit


class L14DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        // 值允许在 iPad 上新建文档
        // 因为只有在 iPad 上才可以实现多任务
        // 这样才允许我们为 EmojiArt 设置背景图片
        if UIDevice.current.userInterfaceIdiom == .pad {
            // 在我们的应用程序的 applicationSupportDirectory 路径新建一个空白的文档
            // 这个模板将被复制到 Documents directory 路径作为新文档
            // 详见 didRequestDocumentCreationWithHandler 代理方法
            template = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask ,
                appropriateFor: nil,
                create: true
//                ).appendingPathComponent("Untitled.json")
                ).appendingPathComponent("Untitled.emojiart")
            // 👆更改为空白模板的名称
            // 结合添加了 emojiart 文件类型
            // 在项目设置中的 Target 的 Info 标签中的 Exported UTIs（自定义一种后缀名为 emojiart 的统一类型标识）
            // 同时在这个标签中修改 Document Type 为 edu.stanford.cs193p.emojiart
            // 这样在系统的“文件”应用程序中，文档就可以被我们的应用程序打开了
            if template != nil {
                // 如果我们无法创建模板
                // 则禁用 UI 上的创建新文档按钮
                allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
            }
        }
    }
    
    var template: URL?
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        // 直接调用传入的处理作用于我们的模板
        // 复制模板以创建一个新的文档
        importHandler(template, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        // 为第一个被选择的文档显示 Document View Controller
        // 如果你支持选择多个文档，其保证你可以全部处理好它们
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // 为新创建的文档显示 Document View Controller
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // 保证恰当地处理导入失败的情况，比如为用户显示一个错误信息
    }
    
    // MARK: 显示文档
    
    func presentDocument(at documentURL: URL)
    {
        let storyBoard = UIStoryboard(name: "L14Main", bundle: nil)
        // 获取我们显示 EmojiArt 文档的 VC
        let documentVC = storyBoard.instantiateViewController(withIdentifier: "DcoumentMVC")
        // 为我们的 EmojiArtViewController 对象配置一个新的 EmojiArtDocument 对象
        // 对于请求的documentURL
        // 注意我们必须使用 documentVC 的 .contents(在 Utilities.swift 中被定义)
        // 以查看包裹 EmojiArtViewController 的 navigation controller 的内容
        if let emojiArtViewController = documentVC.contents as? L14EmojiArtViewController {
            emojiArtViewController.documnet = L14EmojiArtDocument(fileURL: documentURL)
        }
        // 现在以 modally 方式显示文档的 MVC
        // 这会占据整个屏幕直到它自己调用 dismisses: 方法
        present(documentVC, animated: true)
    }
}

