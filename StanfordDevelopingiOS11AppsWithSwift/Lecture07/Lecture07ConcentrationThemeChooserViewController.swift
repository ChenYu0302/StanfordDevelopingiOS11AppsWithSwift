//
//  ConcentrationThemeChooserViewController.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/10.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class Lecture07ConcentrationThemeChooserViewController: Lecture09VCLViewController, UISplitViewControllerDelegate {

    override var vclLoggingName: String {
        return "Theme Chooser"
    }
    
    let themes = [
        "Sports":"⚽️🏀🏓🏐🏸🎾⛷🎱🏈🏉🏒🏏",
        "Faces":"😀😁🤣😂😄😅😆😇😉😊🙂🙃",
        "Animals":"🐃🐂🐄🐪🐫🐘🦏🦍🐅🐆🐊🐐🐏"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
        ) -> Bool {
        if let cvc = secondaryViewController as? Lecture07ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        /*
        // 以下代码功能：选择主题后，不会创建新游戏
        if let cvc = splitViewDetailConcentrationController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }*/
        
        // 以下代码功能：选择主题后，每次都会创建新游戏
        performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
    
    private var splitViewDetailConcentrationController:Lecture07ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? Lecture07ConcentrationViewController
    }
    
    // MARK: - Navigation
    
    private var lastSeguedToConcentrationViewController: Lecture07ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? Lecture07ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
}
