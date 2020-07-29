//
//  BubbleSegment.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

struct BubbleSegmentStyle {
    var indicatorColor = UIColor(white: 0.95, alpha: 1)
    var titleMargin: CGFloat = 16
    var titlePendingHorizontal: CGFloat = 14
    var titlePendingVertical: CGFloat = 14
    var titleFont = UIFont.boldSystemFont(ofSize: 14)
    var normalTitleColor = UIColor.lightGray
    var selectedTitleColor = UIColor.darkGray
    var selectedBorderColor = UIColor.clear
    var normalBorderColor = UIColor.clear
    var minimumWidth: CGFloat?
    
    init() {}
}

class BubbleSegment: UIControl {
    struct TitleElement: Equatable {
        let title: String
        let selectedImage: UIImage?
        let normalImage: UIImage?
        
        init(title: String, selectedImage: UIImage? = nil, normalImage: UIImage? = nil) {
            self.title = title
            self.selectedImage = selectedImage
            self.normalImage = normalImage
        }
        
        static func == (lhs: TitleElement, rhs: TitleElement) -> Bool {
            return lhs.title == rhs.title && lhs.selectedImage == rhs.selectedImage && lhs.normalImage == rhs.selectedImage
        }
    }
    
    // MARK: - Proprties
    var style: BubbleSegmentStyle {
        didSet {
            self.reloadLayout()
        }
    }
    
    var titleFont: UIFont {
        get {
            return self.style.titleFont
        }
        set {
            self.style.titleFont = newValue
        }
    }
    
    var indicatorColor: UIColor {
        get {
            return self.style.indicatorColor
        }
        set {
            self.style.indicatorColor = newValue
        }
    }
    
    var titleMargin: CGFloat {
        get {
            return self.style.titleMargin
        }
        set {
            self.style.titleMargin = newValue
        }
    }
    
    var titlePendingHorizontal: CGFloat {
        get {
            return self.style.titlePendingHorizontal
        }
        set {
            self.style.titlePendingHorizontal = newValue
        }
    }
    
    var titlePendingVertical: CGFloat {
        get {
            return self.style.titlePendingVertical
        }
        set {
            self.style.titlePendingVertical = newValue
        }
    }
    
    var minimumWidth: CGFloat {
        get {
            return self.style.minimumWidth ?? 0
        }
        set {
            self.style.minimumWidth = newValue
        }
    }
    
    var normalTitleColor: UIColor {
        get {
            return self.style.normalTitleColor
        }
        set {
            self.style.normalTitleColor = newValue
        }
    }
    
    var selectedTitleColor: UIColor {
        get {
            return self.style.selectedTitleColor
        }
        set {
            self.style.selectedTitleColor = newValue
        }
    }
    
    var selectedBorderColor: UIColor {
        get {
            return self.style.selectedBorderColor
        }
        set {
            self.style.selectedBorderColor = newValue
        }
    }
    
    var normalBorderColor: UIColor {
        get {
            return self.style.selectedBorderColor
        }
        set {
            self.style.selectedBorderColor = newValue
        }
    }
    
    var titleElements: [TitleElement] {
        get {
            return self._titleElements
        }
    }
    
    var titles: [String] {
        get {
            return self.titleElements.map({ $0.title })
        }
        set {
            self._titleElements = newValue.map({ TitleElement(title: $0) })
        }
    }
    
    override var frame: CGRect {
        didSet {
            guard self.frame.size != oldValue.size else { return }
            self.reloadLayout()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            guard self.bounds.size != oldValue.size else { return }
            self.reloadLayout()
        }
    }
    
    var valueChange: ((Int) -> Void)?
    
    private(set) var selectIndex = 0
    private var titleLabels: [UILabel] = []
    private var _titleElements: [TitleElement] {
        didSet {
            self.reloadData(animated: false, sendAction: false)
        }
    }
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.bounces = true
        view.isPagingEnabled = false
        view.scrollsToTop = false
        view.isScrollEnabled = true
        view.contentInset = UIEdgeInsets.zero
        view.contentOffset = CGPoint.zero
        view.scrollsToTop = false
        return view
    }()
    private let selectContent =  UIView()
    private var indicator: UIView = {
        let ind = UIView()
        ind.layer.masksToBounds = true
        return ind
    }()
    private let selectedLabelsMaskView: UIView = {
        let cover = UIView()
        cover.layer.masksToBounds = true
        return cover
    }()
    
    // MARK: - Init
    convenience override init(frame: CGRect) {
        self.init(frame: frame, segmentStyle: BubbleSegmentStyle(), titles: [])
    }
    
    convenience init(frame: CGRect, titles: [String]) {
        self.init(frame: frame, segmentStyle: BubbleSegmentStyle(), titles: titles)
    }
    
    init(frame: CGRect, segmentStyle: BubbleSegmentStyle, titles: [String]) {
        self.style = segmentStyle
        self._titleElements = titles.map({ TitleElement(title: $0)})
        super.init(frame: frame)
        self.shareInit()
    }
    
    convenience init(frame: CGRect, segmentStyle: BubbleSegmentStyle, richTextTitles: [TitleElement]) {
        self.init(frame: frame, segmentStyle: segmentStyle, titles: [])
        self.setRichTextTitles(richTextTitles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.style = BubbleSegmentStyle()
        self._titleElements = []
        super.init(coder: aDecoder)
        self.shareInit()
    }
    
    // MARK: - Actions
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let x = gesture.location(in: self).x + self.scrollView.contentOffset.x
        for (i, label) in self.titleLabels.enumerated() {
            if x >= label.frame.minX && x <= label.frame.maxX {
                self.setSelectIndex(index: i, animated: true)
                break
            }
        }
        
    }
    
    // MARK: - Methods
    
    func setSelectIndex(index: Int, animated: Bool = true) {
        self.setSelectIndex(index: index, animated: animated, sendAction: true)
    }
    
    func setRichTextTitles(_ titles: [TitleElement]) {
        self._titleElements = titles
    }
    
    private func shareInit() {
        self.addSubview(UIView())
        self.addSubview(self.scrollView)
        self.reloadData()
    }
    
    private func setSelectIndex(index: Int, animated: Bool, sendAction: Bool, forceUpdate: Bool = false) {
        
        guard (index != self.selectIndex || forceUpdate), index >= 0, index < self.titleLabels.count else { return }
        
        let currentLabel = self.titleLabels[index]
        let offSetX = min(max(0, currentLabel.center.x - self.bounds.width / 2),
                          max(0, self.scrollView.contentSize.width - self.bounds.width))
        self.scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
        
        if animated {
            
            UIView.animate(withDuration: 0.2, animations: {
                var rect = self.indicator.frame
                rect.origin.x = currentLabel.frame.origin.x
                rect.size.width = currentLabel.frame.size.width
                self.setIndicatorFrame(rect)
            })
            
        } else {
            var rect = self.indicator.frame
            rect.origin.x = currentLabel.frame.origin.x
            rect.size.width = currentLabel.frame.size.width
            self.setIndicatorFrame(rect)
        }
        
        self.selectIndex = index
        if sendAction {
            self.valueChange?(index)
            sendActions(for: .valueChanged)
        }
    }
    
    private func setIndicatorFrame(_ frame: CGRect) {
        self.indicator.frame = frame
        self.selectedLabelsMaskView.frame = frame
        
    }
    
    // Data handler
    private func reloadLayout() {
        self.reloadData(animated: false, sendAction: false)
    }
    
    private func clearData() {
        self.scrollView.subviews.forEach { $0.removeFromSuperview() }
        self.selectContent.subviews.forEach { $0.removeFromSuperview() }
        if let gescs = gestureRecognizers {
            for gesc in gescs {
                removeGestureRecognizer(gesc)
            }
        }
        self.titleLabels.removeAll()
    }
    
    private func reloadData(animated: Bool = true, sendAction: Bool = true) {
        self.clearData()
        
        guard self.titles.count > 0  else {
            return
        }
        // Set titles
        let font  = self.style.titleFont
        var titleX: CGFloat = 0.0
        var titleH = font.lineHeight
        if self.titleElements.contains(where: { $0.normalImage != nil }) || self.titleElements.contains(where: { $0.selectedImage != nil }) {
            titleH = titleH + self.style.titlePendingVertical
        }
        let titleY: CGFloat = (self.bounds.height - titleH)/2
        let coverH: CGFloat = font.lineHeight + self.style.titlePendingVertical
        
        self.selectedLabelsMaskView.backgroundColor = UIColor.black
        self.scrollView.frame = self.bounds
        self.selectContent.frame = self.bounds
        self.selectContent.layer.mask = self.selectedLabelsMaskView.layer
        self.selectedLabelsMaskView.isUserInteractionEnabled = true
        
        let toToSize: (String) -> CGFloat = { text in
            let result =  (text as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0.0), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).width
            
            if let minWidth = self.style.minimumWidth, result < minWidth {
                return minWidth
            }
            return result
        }
        
        for (index, item) in self.titleElements.enumerated() {
            
            var titlePendingHorizontal = self.style.titlePendingHorizontal
            
            //if we are using images, then add a bit of extra horizontal spacing
            if item.normalImage != nil || item.selectedImage != nil {
                titlePendingHorizontal = titlePendingHorizontal + font.lineHeight
            }
            
            let titleW = toToSize(item.title) + titlePendingHorizontal * 2
            
            titleX = (self.titleLabels.last?.frame.maxX ?? 0 ) + self.style.titleMargin
            let rect = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            
            let backLabel = UILabel(frame: CGRect.zero)
            backLabel.tag = index
            backLabel.text = item.title
            backLabel.textColor = self.style.normalTitleColor
            backLabel.font = self.style.titleFont
            backLabel.textAlignment = .center
            backLabel.frame = rect
            
            if self.style.normalBorderColor != .clear {
                backLabel.layer.borderColor = UIColor.darkGray.cgColor
                backLabel.layer.borderWidth = 2
                backLabel.layer.cornerRadius = backLabel.frame.size.height / 2
            }
            
            if let normalImage = item.normalImage {
                backLabel.addToLeft(image: normalImage)
            }
            
            let frontLabel = UILabel(frame: CGRect.zero)
            frontLabel.tag = index
            frontLabel.text = item.title
            frontLabel.textColor = self.style.selectedTitleColor
            frontLabel.font = self.style.titleFont
            frontLabel.textAlignment = .center
            frontLabel.frame = rect
            if let selectedImage = item.selectedImage {
                frontLabel.addToLeft(image: selectedImage)
            }
            
            self.titleLabels.append(backLabel)
            self.scrollView.addSubview(backLabel)
            self.selectContent.addSubview(frontLabel)
            
            if index == self.titles.count - 1 {
                self.scrollView.contentSize.width = rect.maxX + self.style.titleMargin
                self.selectContent.frame.size.width = rect.maxX + self.style.titleMargin
            }
        }
        
        // Set Cover
        self.indicator.layer.borderWidth = 2
        self.indicator.layer.borderColor = self.style.selectedBorderColor.cgColor
        self.indicator.backgroundColor = self.style.indicatorColor
        self.scrollView.addSubview(self.indicator)
        self.scrollView.addSubview(self.selectContent)
        
        let coverX = self.titleLabels[0].frame.origin.x
        let coverY = (self.bounds.size.height - coverH) / 2
        let coverW = self.titleLabels[0].frame.size.width
        
        let indRect = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        self.setIndicatorFrame(indRect)
        
        self.indicator.layer.cornerRadius = coverH/2
        self.selectedLabelsMaskView.layer.cornerRadius = coverH/2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BubbleSegment.handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
        
        self.setSelectIndex(index: selectIndex, animated: animated, sendAction: sendAction, forceUpdate: true)
        
    }
}

extension UILabel {
    @objc  func addToLeft(image: UIImage?) {
        let mutableAttributedString = NSMutableAttributedString()
        if let image = image {
            let attachment = NSTextAttachment()
            attachment.image = image
            var size = image.size
            if size.height > bounds.height {
                size.height = bounds.height
                size.width = size.height * bounds.width / bounds.height
            }
            
            attachment.bounds = CGRect(x: 0, y: (self.font.capHeight - size.height) / 2, width: image.size.width, height: image.size.height)
            let attachmentStr = NSAttributedString(attachment: attachment)
            mutableAttributedString.append(attachmentStr)
        }
        if let text = self.text {
            let textString = NSAttributedString(string: text, attributes: [.font: self.font as Any, .foregroundColor: self.textColor as Any])
            mutableAttributedString.append(textString)
        }
        self.attributedText = mutableAttributedString
    }
}
