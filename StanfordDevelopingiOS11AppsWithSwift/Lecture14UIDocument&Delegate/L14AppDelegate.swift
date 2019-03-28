//
//  AppDelegate.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/2/27.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

@UIApplicationMain
class L14AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 在此处重写应用程序启动后的自定义行为。
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // 应用程序即将从活动状态转为非活动状态时，调用该方法。 对于某些类型的临时中断（例如来电或SMS消息）或当用户退出应用程序并且它开始转换到后台状态时，就会发生。
        // 使用此方法可暂停正在进行的任务，禁用计时器以及使图形渲染回调无效。 游戏应该调用该方法暂停游戏。
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // 使用这个方法实现：释放共享的资源，保存我们的数据，使定时器失效，以及存放足够的应用程序状态信息以备份应用程序的当前状态以防d随后它被终止。
        // 如果你的应用程序之处后台运行，当用户退出时，这个方法将被调用，而不是 applicationWillTerminate:
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // 应用程序从后台变为活动状态时调用这一部分；这里你可以撤销许多在进入后台时发生的改变
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 重启任何在应用程序处于非活动状态下被暂停（或还没开始）的任务。如果应用程序之前处于后台状态，则选择性地刷新用户界面
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // 当应用程序将要终结时被调用。如果需要，保存数据。参间 applicationDidEnterBackground:。
    }
    
    
    // 下面的方法由 Document 工程模板提供
    // 实现了一个被其他应用程序调用的方法
    // （比如系统自带的“文件”应用程序）
    // 如果其他的应用程序想要在你的应用程序打开一个文档
    // 这只会对那些已经被定义在 Project Settings/Target/Info 里，作为输出的统一类型标识符的文档起作用
    // 简单地令 DocumentBrowserViewController展示文档
    
    func application(_ app: UIApplication, open inputURL: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 保证 URL 是一个文件 URL
        guard inputURL.isFileURL else { return false }
        
        // 展示 / 输入 URL 里的文档
        guard let documentBrowserViewController = window?.rootViewController as? L14DocumentBrowserViewController else { return false }
        
        documentBrowserViewController.revealDocument(at: inputURL, importIfNeeded: true) { (revealedDocumentURL, error) in
            if let error = error {
                // 适当地处理错误
                print("Failed to reveal the document at URL \(inputURL) with error: '\(error)'")
                return
            }
            
            // 为要展示的 URL 显示 DocumentViewController
            documentBrowserViewController.presentDocument(at: revealedDocumentURL!)
        }
        
        return true
    }
}

