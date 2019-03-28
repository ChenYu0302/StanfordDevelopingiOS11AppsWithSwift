//
//  Lecture14EmojiArtView+Gestures.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/16.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

// 对L14EmojiArtView的手势识别扩展
extension L14EmojiArtView
{
    /// 为 Emoji 添加手势识别
    func addEmojiArtGestureRecognizers(to view: UIView) {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectSubview(by:))))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.selectAndMoveSubview(by:))))
    }
    
    /// 被选中的视图，其中被选择的视图会有宽度为1的方框
    var selectedSubview: UIView? {
        get { return subviews.filter { $0.layer.borderWidth > 0 }.first }
        set {
            subviews.forEach { $0.layer.borderWidth = 0 }
            newValue?.layer.borderWidth = 1
            if newValue != nil {
                enableRecognizers()
            } else {
                disableRecognizers()
            }
        }
    }
    
    /// 选择子视图
    @objc func selectSubview(by recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            selectedSubview = recognizer.view
        }
    }
    
    /// 拖动与缩放子视图
    @objc func selectAndMoveSubview(by recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if selectedSubview != nil, recognizer.view != nil {
                selectedSubview = recognizer.view
            }
        case .changed, .ended:
            if selectedSubview != nil {
                recognizer.view?.center = recognizer.view!.center.offset(by: recognizer.translation(in: self))
                recognizer.setTranslation(CGPoint.zero, in: self)
                if recognizer.state == .ended {
                    delegate?.emojiArtViewDidChange(self)  // 调用代理
                }
            }
        default:
            break
        }
    }
    
    /// 使能手势
    func enableRecognizers() {
        if let scrollView = superview as? UIScrollView {
            // if we are in a scroll view, disable its recognizers
            // 如果我们在一个 scrollView 中，则禁用它的手势识别
            // so that ours will get the touch events instead
            // 这样我们的视图就可以获得触摸事件
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.pinchGestureRecognizer?.isEnabled = false
        }
        if gestureRecognizers == nil || gestureRecognizers!.count == 0 {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.deselectSubview)))
            addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.resizeSelectedLabel(by:))))
        } else {
            gestureRecognizers?.forEach { $0.isEnabled = true }
        }
    }
    
    /// 禁用手势
    func disableRecognizers() {
        if let scrollView = superview as? UIScrollView {
            // if we are in a scroll view, re-enable its recognizers
            // // 如果我们不在一个 scrollView 中，则重新使能它的手势识别
            scrollView.panGestureRecognizer.isEnabled = true
            scrollView.pinchGestureRecognizer?.isEnabled = true
        }
        gestureRecognizers?.forEach { $0.isEnabled = false }
    }
    
    /// 取消选择子视图
    @objc func deselectSubview() {
        selectedSubview = nil
    }
    
    /// 将被选择的标签重置为默认大小
    @objc func resizeSelectedLabel(by recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            if let label = selectedSubview as? UILabel {
                label.attributedText = label.attributedText?.withFontScaled(by: recognizer.scale)
                label.stretchToFit()
                recognizer.scale = 1.0
                if recognizer.state == .ended {
                    delegate?.emojiArtViewDidChange(self) // 调用代理
                }
            }
        default:
            break
        }
    }
    
    /// 将子视图放至底层
    @objc func selectAndSendSubviewToBack(by recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if let view = recognizer.view, let index = subviews.index(of: view) {
                selectedSubview = view
                exchangeSubview(at: 0, withSubviewAt: index)
                delegate?.emojiArtViewDidChange(self)  // 调用代理
            }
        }
    }
}
