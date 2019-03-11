//
//  Lecture09VCLViewController.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/11.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class Lecture09VCLViewController: UIViewController {
    
    private struct LogGlobals {
        var prefix = ""
        var instanceCounts = [String:Int]()
        var lastLogTime = Date()
        var indentationInterval:TimeInterval = 1
        var indentationString = "__"
    }
    
    private static var logGlobals = LogGlobals()
    
    private static func logPrefix(for loggingName:String) -> String {
        if logGlobals.lastLogTime.timeIntervalSinceNow < -logGlobals.indentationInterval {
            logGlobals.prefix += logGlobals.indentationString
            print("")
        }
        logGlobals.lastLogTime = Date()
        return logGlobals.prefix + loggingName
    }
    
    private static func bumpInstanceCount(for loggingName: String) -> Int {
        logGlobals.instanceCounts[loggingName] = (logGlobals.instanceCounts[loggingName] ?? 0) + 1
        return logGlobals.instanceCounts[loggingName]!
    }
    
    private var instanceCount: Int!
    
    var vclLoggingName:String {
        return String(describing: type(of: self))
    }
    
    private func logLCV(_ message:String) {
        if  instanceCount == nil {
            instanceCount = Lecture09VCLViewController.bumpInstanceCount(for: vclLoggingName)
        }
        print("\(Lecture09VCLViewController.logPrefix(for: vclLoggingName)) \(instanceCount!) \(message)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        logLCV("init(coder:) - created via InterfaceBulider")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        logLCV("init(nibName:bundle:) - created in code")
    }
    
    deinit {
        logLCV("left the heap")
    }
    
    override func awakeFromNib() {
        logLCV("awakeFromNib()")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logLCV("viewDidLoad()")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logLCV("viewWillAppear(animated = \(animated)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logLCV("viewDidAppear(animated = \(animated)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logLCV("viewWillDisappear(animated = \(animated)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logLCV("viewDidDisappear(animated = \(animated)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        logLCV("didReceiveMemoryWarning()")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logLCV("viewWillLayoutSubviews()")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logLCV("viewDidLayoutSubviews()")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        logLCV("viewWillTransition(to: \(size), with: \(coordinator)")
        coordinator.animate(
            alongsideTransition:
            {
                (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.logLCV("begin animate(alongsideTransition: completion)")
        },
            completion:
            { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.logLCV("end animate(alongsideTransition: completion")
        }
        )
    }
}
