//
//  L16DocumentInfoViewController.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/25.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class L16DocumentInfoViewController: UIViewController {
    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if let fittedSize = tople {
//            <#statements#>
//        }
//    }
//    
    
    @IBAction func done() {
        presentingViewController?.dismiss(animated: true)
    }
    @IBOutlet weak var thumbnailAspectRatio: NSLayoutConstraint!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var szieLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
}
