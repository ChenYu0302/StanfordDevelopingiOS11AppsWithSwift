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
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            template = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask ,
                appropriateFor: nil,
                create: true
                ).appendingPathComponent("Untitled.json")
            if template != nil {
                allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data()) // 如果能够成功创建文件，则允许创建文档
            }
        }
    }
    
    var template: URL?
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        
        
        importHandler(template, .copy) // 复制模板以创建一个新的文档
        
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        // 显示文档
        let storyBoard = UIStoryboard(name: "L14Main", bundle: nil)
        
        let documentVC = storyBoard.instantiateViewController(withIdentifier: "DcoumentMVC")
        
        if let emojiArtViewController = documentVC.contents as? L14EmojiArtViewController {
            emojiArtViewController.documnet = L14EmojiArtDocument(fileURL: documentURL)
            
            
            
        }
        
        present(documentVC, animated: true)
        
    }
}

