//
//  Lecture14EmojiArtView.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/14.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

// 这是 EmojiArtView 的代理协议
// 想要让他的控制器知道它的内容发生了改变
// 但是 MVC 不予许视图拥有指向他的控制器的指针
// 它必须以“盲箱地”进行沟通
// 这就是这种沟通方式的“结构”
// 详见下方的EmojiArtView的代理变量
// 注意这个协议只能被类实现
// （而不是结构体或枚举）
// 这是因为这种类型的变量必须是 weak 的
// （以避免内存循环）
// weak意味着他保存在 heap 中
// 这意味着它是一个引用类型（比如一个类）

protocol L14EmojiArtViewDelegate: class {
    func emojiArtViewDidChange(_ sender: L14EmojiArtView)
}

class L14EmojiArtView: UIView, UIDropInteractionDelegate
{
    // MARK: - Delegation
    
    // 如果一个控制器想要知道什么时候在这个 EmojiArtView 中发生了某些改变
    // 这个控制器必须遵循 EmojiArtView 的协议并设置自己为代理
    // 这样控制器就可以在它那里启动协议里的方法
    // 在发生改变的任何时候，这个代理会被通知
    // （在 EmojiArtView+Gestures.swift 中查看这个代理的使用）
    // 这个变量是 weak 的所以他不会造成内存循环
    // (i.e. the Controller points to its View and its View points back)
    weak var delegate: L14EmojiArtViewDelegate?
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addInteraction(UIDropInteraction(delegate: self))
    }
    
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64.0))
    }
    
    // MARK: - UIDropInteractionDelegate
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSAttributedString.self) { providers in
            let dropPiont = session.location(in: self)
            for attributedString in providers as? [NSAttributedString] ?? [] {
                self.addLabel(with: attributedString, centerdAt: dropPiont)
                self.delegate?.emojiArtViewDidChange(self) // 如果放置了 emoji 则调用我的代理属性内的 emojiArtViewDidChange:
            }
        }
    }
    
    func addLabel(with attributedString: NSAttributedString, centerdAt point: CGPoint) {
        let label = UILabel()
        label.backgroundColor = .clear
        label.attributedText = attributedString.font != nil ? attributedString : NSAttributedString(string: attributedString.string,attributes: [.font:self.font])
//        label.attributedText = attributedString
        label.sizeToFit()
        label.center = point
        addEmojiArtGestureRecognizers(to: label)
        addSubview(label)
    }
    
    // MARK: - 绘制背景
    
    var backgroundImage: UIImage? { didSet {setNeedsDisplay()} }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
}

