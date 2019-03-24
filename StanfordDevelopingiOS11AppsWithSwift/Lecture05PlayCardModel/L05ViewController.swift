//
//  Lecture05ViewController.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/7.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class L05ViewController: UIViewController {
    
    
    var deck = L05PlayingCardDeck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...10 {
            if let card = deck.draw() {
                print(card)
            }
        }
    }
}
