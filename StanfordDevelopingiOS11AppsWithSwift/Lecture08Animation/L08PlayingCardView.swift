//
//  Lecture08PlayingCardView.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/11.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

@IBDesignable class L08PlayingCardView: UIView {
    
    @IBInspectable var rank: Int = 1 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable var suit: String = "♥️" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable var isFaceUp: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var faceCardScale:CGFloat = SizeRatio.faceCardImageSizeSizeToBoundsSize { didSet { setNeedsDisplay() } }
    
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer : UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed,.ended:
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }
    
    private func centeredAttributedString(_ string:String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString.init(string: string, attributes: [.font: font, .paragraphStyle: paragraphStyle])
    }
    
    private var cornerString:NSAttributedString {
        return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }
    
    private lazy var upperCornerLabel = creatCornerLabel()
    private lazy var lowerCornerLabel = creatCornerLabel()
    
    private func creatCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCornerLabel(upperCornerLabel)
        configureCornerLabel(lowerCornerLabel)
        upperCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        lowerCornerLabel.transform = CGAffineTransform.identity
            .translatedBy(x: lowerCornerLabel.frame.size.width, y: lowerCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)
        lowerCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerCornerLabel.frame.size.width, dy: -lowerCornerLabel.frame.size.height)
    }
    
    private func drawPips() {
        let pipsPerRowForRank = [
            [0],
            [1],
            [1,1],
            [1,1,1],
            [2,2],
            [2,1,2],
            [2,2,2],
            [2,1,2,2],
            [2,2,2,2],
            [2,2,1,2,2],
            [2,2,2,2,2]
        ]
        
        func creatPipString(thatFits pipRect:CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attempedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attempedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            }else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds
                .insetBy(dx: cornerOffset, dy: cornerOffset)
                .insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = creatPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHarf)
                    pipString.draw(in: pipRect.RightHarf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: SizeRatio.cornerRadiusToBoundsHeight * bounds.height)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp {
            if let faceCardImage = UIImage(named: rankString+suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by:faceCardScale))
            } else {
                drawPips()
            }
        } else {
            if let backCardImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection)  {
                backCardImage.draw(in: bounds)
            }
        }
    }
}

extension L08PlayingCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.08
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat {return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight}
    private var cornerOffset: CGFloat {return cornerRadius * SizeRatio.cornerOffsetToCornerRadius}
    private var cornerFontSize: CGFloat {return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight}
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

/*
extension CGRect {
    var leftHarf:CGRect { return CGRect(x: midX, y: minY, width: width/2, height: height)}
    var RightHarf:CGRect { return CGRect(x: minX, y: minY, width: width/2, height: height)}
    func inset(by size:CGSize) -> CGRect { return insetBy(dx: size.width, dy: size.height)}
    func sized(to size:CGSize) -> CGRect { return CGRect(origin: origin, size: size)}
    func zoom(by scale:CGFloat) -> CGRect { return insetBy(dx: width*(1-scale)/2, dy: height*(1-scale)/2)}
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
*/
