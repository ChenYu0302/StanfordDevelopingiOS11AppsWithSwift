//
//  Lecture10CassiniViewController.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/11.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class Lecture10CassiniViewController: UIViewController {

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let url = Lecture10DemoURLs.NASA[identifier] {
                if let imageVC = segue.destination.contents as? Lecture10ImageViewController {
                    imageVC.imageURL = url
                    imageVC.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
