//
//  EmojiArtViewController.swift
//  StanfordDevelopingiOS11AppsWithSwift
//
//  Created by 陈宇 on 2019/3/12.
//  Copyright © 2019 chenyu0302. All rights reserved.
//

import UIKit

class L14EmojiArtViewController: UIViewController,UIDropInteractionDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate, L14EmojiArtViewDelegate
{
    
     // MARK: - Model
    
    // 将我们的模型设为计算属性
    // 一旦被设置，则更新 UI
    // 一旦被获取，则返回 UI 的模型
    
    var emojiArt: L14EmojiArt? {
        get {
            if let url = emojiArtBackgroundImage.url {
                let emojis = emojiArtView.subviews.compactMap { $0 as? UILabel }.compactMap { L14EmojiArt.EmojiInfo(label: $0) }
                return L14EmojiArt(url: url, emojis: emojis)
            }
            return nil
        }
        set {
            emojiArtBackgroundImage = (nil, nil)
            emojiArtView.subviews.compactMap { $0 as? UILabel }.forEach {$0.removeFromSuperview()}
            if let url = newValue?.url {
                imageFetcher = L14ImageFetcher(fetch: url) { (url, image) in
                    DispatchQueue.main.async {
                        self.emojiArtBackgroundImage = (url, image)
                        newValue?.emojis.forEach {
                            let attributedText = $0.text.attributedString(withTextStyle: .body, ofSize: CGFloat($0.size))
                            self.emojiArtView.addLabel(with: attributedText, centerdAt: CGPoint(x: $0.x, y: $0.y))
                        }
                    }
                }
            }
        }
    }
    
    var documnet: L14EmojiArtDocument?
    
    // 这里不再使用按钮触发 save:
    // 因为现在我们是 EmojiArtView 的委托
    // （在下方搜索 "delegate = self"）
    // 当 EmojiArtView 发生改变时，我们会被提醒
    // （当放入一张新图片时我们也会被提醒，在下方搜索 "documentChanged"）
    // 同时我们可以更新我们的 UIDocument's 的模型至符合我们的模型
    // 同时告诉我们的 UIDocument 它发生了改变
    // 同时它会在合适时候自动保存

//    @IBAction func save(_ sender: UIBarButtonItem? = nil) {
    func documentChanged() {
        documnet?.emojiArt = emojiArt
        if documnet?.emojiArt != nil {
            documnet?.updateChangeCount(.done)
        }
    }
    

    
    @IBAction func close(_ sender: UIBarButtonItem) {
//        save() // 文件会自动保存，所以这里在关闭前无需保存文件
        if documnet?.emojiArt != nil{
            documnet?.thumbnail = emojiArtView.snapshot
        }
        dismiss(animated: true) {
            self.documnet?.close()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 无论我们什么时候出现，我们都会打开我们的文档
        // （值得一提的是，我们也会在我们相识的时候关闭它）
        documnet?.open { success in
            if success {
                self.title = self.documnet?.localizedName
                // 根据我们的文档的模型，更新我们的模型
                self.emojiArt = self.documnet?.emojiArt
            }
        }
    }
    
    // MARK: - Storyboard
    
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    
    // 修改我们在 storyboard 中 scroll view 的长和宽的约束
    // 修改至与 scroll view 的内容区域大小一致
    // “长和宽”的约束是的优先级低于“stay within the edges”和"保持 scroll view 位于中央"
    // 所以这对于非常大的内容区域依旧起作用
    // (当你放大时，一个 scroll view 的内容区域将会变得很大)
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return emojiArtView
    }
    
    // MARK: - Emoji Art View
    
    // 当我们创建了我们的 EmojiArtView ，我们同时也会设置它的代理为 self
    // so that we can get emojiArtViewDidChange messages sent to us
    
    lazy var emojiArtView: L14EmojiArtView = {
        let eav = L14EmojiArtView()
        eav.delegate = self
        return eav
    }()
    
    // EmojiArtViewDelegate
    
    func emojiArtViewDidChange(_ sender: L14EmojiArtView) {
        // 让我们的文档知道文档发生了改变
        // 这样它就会在恰当时机自动保存
        documentChanged()
    }
    
    // 定义了一个元组
    // 这样无论什么时候设置了背景图片
    // 我们都获取了照片的 url
    
    var emojiArtBackgroundImage: (url: URL?, image: UIImage?) {
        get {
            return (_emojiArtBackgroundImageURL, emojiArtView.backgroundImage)
        }
        set {
            _emojiArtBackgroundImageURL = newValue.url
            scrollView?.zoomScale = 1.0
            emojiArtView.backgroundImage = newValue.image
            let size = newValue.image?.size ?? CGSize.zero
            emojiArtView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView.contentSize = size
            scrollViewHeight?.constant = size.height
            scrollViewWidth?.constant = size.width
            if let dropZone = self.dropZone, size.width > 0, size.height > 0  {
                scrollView?.zoomScale = max(dropZone.bounds.size.width / size.width, dropZone.bounds.size.height / size.height)
            }
        }
    }
    
    private var _emojiArtBackgroundImageURL: URL?
    
    
    // MARK: - Emoji Colletion View
    
    // 原本是一个 emoji 字符串
    // 我们想要这个变量变为字符串数组
    // 所以使用 .map对其转换
    
    var emojis = "😁✈️🐷☎️🌈🎵🎼♣️👻🤡🎱☕️✏️".map { String($0) }
    
    @IBOutlet weak var emojiColletionView: UICollectionView! {
        didSet {
            emojiColletionView.dataSource = self
            emojiColletionView.delegate = self
            emojiColletionView.dragDelegate = self
            emojiColletionView.dropDelegate = self
            // 默认在 iPhone 下是，在一个 Collection View 中拖动是被禁用的
            // 我们希望它在所有的平台都可用
            emojiColletionView.dragInteractionEnabled = true
        }
    }
    
    private var font: UIFont {
        // 为用户调整字体大小
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body)).withSize(64.0)
    }
    
    // addingEmoji 表示我们正在对 text field 输入
    // 它位于我们的 Collection View 的 section 0 位置
    // 这允许我们对我们的 Collection View 添加更多的 emoji
    
    private var addingEmoji = false
    
    @IBAction func addEmoji() {
        addingEmoji = true
        // 重新载入 section 0 因为现在它包含着一个 text field 而不是一个按钮
        emojiColletionView.reloadSections(IndexSet(integer: 0))
    }
    
    // MARK: - UIColletionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // section 0: 用于添加 emoji 的 button 或 text field
        // section 1: 我们的 emoji
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1             // 一个 button 或一个 text field cell
        case 1: return emojis.count  // 我们的 emoji
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            // 我们的 emoji 正使用 EmojiCollectionViewCell 进行展示
            // 这个 EmojiCollectionViewCell 有一个着展示 emoji 的 lable 的 outlet
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
            if let emojiCell = cell as? L14EmojiCollectionViewCell {
                let text = NSAttributedString(string: emojis[indexPath.row], attributes: [.font:font])
                emojiCell.label.attributedText = text
            }
            return cell
        } else if addingEmoji {
            // 如果我们正在添加 emoji（同时我们被索取 section 0 的 cell）
            // 这就需要我们的 EmojiInputCell，它内部有一个 text field
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiInputCell", for: indexPath)
            if let inputCell = cell as? L14TextFieldCollectionViewCell {
                // 当 cell 的 text field 变为 first responder 时，resignationHandler 被调用（即：不是 text field 接收到键盘输入）
                inputCell.resignationHandler = { [weak self, unowned inputCell] in
                    // 令 self 为 weak 和令 inputCell 为 unowned 以防止内存循环
                    if let text = inputCell.textField.text {
                        self?.emojis = (text.map { String($0)} + self!.emojis).uniquified
                        self?.addingEmoji = false
                        // 重载Collection Viewc
                        // 因为 section 0 即将发生改变 (变回带有 + 按钮的 cell)
                        // 页因为我们已经添加了一个新的 emoji 到了 section 1
                        self?.emojiColletionView.reloadData()
                    }
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddEmojiButtonCell", for: indexPath)
            return cell
        }
    }
    
    // MARK: - UIColletionViewDelegateFlowLayout
    
    // 当显示 text field 时 section 0 的 cell 应该宽一点 (i.e. we're addingEmoji)
    // 注意我们这里使用常量
    // 这并不好
    // 我们应该根据我们的 emoji 字体的尺寸计算我们的 cell 的高度
    // 我们应该根据这个设置 Collection View 的高度
    // （通过一个 storyboard 里的 Collection View 的约束的 outlet ）
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if addingEmoji && indexPath.section == 0 {
            return CGSize(width: 300, height: 80)
        } else {
            return CGSize(width: 80, height: 80)
        }
    }
    
    // MARK: - UIColletionViewDelegate
    
    // 在为添加 emoji 而显示 text field 之前
    // 让我们使它变为 first responder 这样就会出现键盘
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let inputCell = cell as? L14TextFieldCollectionViewCell {
            inputCell.textField.becomeFirstResponder()
        }
    }
    
    // MARK: - UIColletionViewDragDelegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView  // 这样我们知道拖动的“是自己”
        return dargItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dargItems(at: indexPath)
    }
    
    private func dargItems(at indexPath:IndexPath) -> [UIDragItem]{
        // 当我们在添加 emoji 时防止拖动
        // cellForItem(at:) 只对可见的 cell 有效
        // 但是如果我们拖动的是 cell，那它一定是可见的
        if !addingEmoji, let attributedString = (emojiColletionView.cellForItem(at: indexPath) as? L14EmojiCollectionViewCell)?.label.attributedText  {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedString))
            dragItem.localObject = attributedString
            return [dragItem]
        } else {
            return []
        }
    }
    
    // MARK: - UIColletionViewDropDelegate
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?
        ) -> UICollectionViewDropProposal {
        if let indexPath = destinationIndexPath, indexPath.section == 1 {
            let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
            return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        performDropWith coordinator: UICollectionViewDropCoordinator
        ) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items { // item 是 UICollectionViewDropItem 对象，可能有多个 items
            if let sourceIndexPath = item.sourceIndexPath {
                if let attributedString = item.dragItem.localObject as? NSAttributedString {
                    collectionView.performBatchUpdates({ // 对 Table 和 CollectionView 的数据做多步操作时，使用该方法可以同步运行时引发的程序奔溃，以下的程序认为是一步操作。
                        emojis.remove(at: sourceIndexPath.item)
                        emojis.insert(attributedString.string, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                let placeholderContext = coordinator.drop(
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell")
                )
                // 用异步方式获取数据
                item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self) { (provider, error) in
                    // 当它到达时，返回主队列...
                    DispatchQueue.main.async {
                        // ... 抓住落下的字符串 ...
                        if let attributedString = provider as? NSAttributedString{
                            // ... 然后替换占位控件
                            // 我们只需对更新模型负责
                            // Collection View 会用一个 cell 处理好替换占位控件
                            // 通过调用我们的 cellForItem(at:) 数据源方法
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.emojis.insert(attributedString.string, at: insertionIndexPath.item)
                            })
                        } else {
                            // 出于某些原因我们无法获得数据
                            // 所以删除占位控件
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - UIDropInteractionDelegate
    
    // 这是我们的 dropZone 的放置（不是 Collection View）
    // 我们只接受可以同时提供 URL 和 UIImage 数据的放置
    // 我们希望 URL 是一个UIImage的 URL（并不强求）
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    // ImageFetcher 在 Utility.swift 中定义
    // 它获取一个 url 但也允许定义一个“备份”图片
    // 如果它必须使用备份图片，则将它放到文件系统里
    // 比如这样对于保存在iCloud Drive 的文档它就不能很好地工作
    // 也让Demo更加顺畅 :)
    
    var imageFetcher: L14ImageFetcher!
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        imageFetcher = L14ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                // 我们已经从url获得了放下的图片
                // （或者我们回去使用了备份图片）
                // 现在为我们的EmojiArt文档设置新的背景
                self.emojiArtBackgroundImage = (url, image)
                // 此外，当 emoji 添加到了我们的 EmojiArtView 上
                // 也会造成我们的文档改变
                // 无论什么时候放置了新的背景图片
                // 我们的文档也会发生改变
                // 这样我们都会知道
            }
        }
        
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            if let url = nsurls.first as? URL {
                self.imageFetcher.fetch(url)
            }
        }
        
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage {
                self.imageFetcher.backup = image
            }
        }
    }
}

// 对模型的扩展
// 注意：这里面有“ UI 事物”
// 因为他使用到了 UILabel
// 这并没有什么问题，因为这些代码在我们的控制器里
// （即使它是对模型的扩展）
// 对于 MVC 的设计模式，代码写在哪里决定了代码的MVC角色

// 这里根据一个 UILabel 创建了一个 EmojiArt.EmojiInfo
// 这是一个可以失败的初始化器
// 如果无法从一个输入 UILabel 创建一个 EmojiInfo，则返回 nil

extension L14EmojiArt.EmojiInfo //这里的扩展认为是对 Controller 扩展，而非 Model
{
    init?(label:UILabel) {
        if let attributedText = label.attributedText, let font = attributedText.font {
            x = Int(label.center.x)
            y = Int(label.center.y)
            text = attributedText.string
            size = Int(font.pointSize)
        }  else {
            return nil // 初始化失败
        }
    }
}


