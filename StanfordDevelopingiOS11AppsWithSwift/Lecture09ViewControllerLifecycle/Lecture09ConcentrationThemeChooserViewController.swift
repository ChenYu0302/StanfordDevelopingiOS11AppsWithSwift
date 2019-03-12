//
//  Lecture09ConcentrationThemeChooserViewController.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/12.
//  Copyright © 2019 chenyu0302. All rights reserved.
//


import UIKit

class Lecture09ConcentrationThemeChooserViewController: Lecture09VCLViewController, UISplitViewControllerDelegate {
    
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
        if let cvc = secondaryViewController as? Lecture09ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
    
    private var splitViewDetailConcentrationController:Lecture09ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? Lecture09ConcentrationViewController
    }
    
    // MARK: - Navigation
    
    private var lastSeguedToConcentrationViewController: Lecture09ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? Lecture09ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
}
