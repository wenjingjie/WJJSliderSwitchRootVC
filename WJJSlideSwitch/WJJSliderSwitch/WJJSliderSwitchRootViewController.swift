//
//  WJJSliderSwitchRootViewController.swift
//  WJJSliderSwitch
//
//  Created by wenjingjie on 2018/8/10.
//  Copyright © 2018年 wjj. All rights reserved.
//


import UIKit

let iphoneX = UIScreen.main.currentMode?.size.equalTo(CGSize(width: 1125, height: 2436)) ?? false
let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let StatusBarHeight: CGFloat = iphoneX ? 44 : 20
let NavBarHeight: CGFloat = 44.0
let TopBarHeight = StatusBarHeight + NavBarHeight
let TabBarHeight: CGFloat = iphoneX ? 83.0 : 49.0
let HomeIndicatorHeight: CGFloat = iphoneX ? 34 : 0
let TopGapHeight: CGFloat = iphoneX ? 24 : 0
private let titleSlideBottomW = CGFloat(27)

class WJJSliderSwitchRootViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var titlesScrollerView = UIScrollView()
    var selectedTitleButton = UIButton()
    var titleBottomView = UIView()
    var titleButtons = [UIButton]()
    var defaultIndex = 0  // 默认选中第1个
    var titleMargin:CGFloat = 30 // 标题间距
    var titlesScrollerViewContentWidth = CGFloat()
    var textWidthArray = [CGFloat]()
    var titleArray = ["标题1","标题标题2","标题3","标题标题标题4","标题5","标题标题标题标题6",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "标题"
        self.setupScrollView()
        self.setupTitlesView()
        self.setupChildController()
    }
    
    func setupChildController() {
        for _ in self.titleArray {
            let vc = WJJChildViewController()
            self.addChildViewController(vc)
        }
    }
}

//MARK:-UIScrollViewDelegate
extension WJJSliderSwitchRootViewController: UIScrollViewDelegate {
    
    func setupTitlesView() {
        self.view.backgroundColor = UIColor.white
        for name in self.titleArray {
            let nameWidth = name.width(ScreenWidth, fontSize: 15)
            titlesScrollerViewContentWidth += (nameWidth + titleMargin)
        }
        self.titlesScrollerView.frame = CGRect(x: 0, y: TopBarHeight, width: ScreenWidth, height: 40)
        titlesScrollerView.backgroundColor = UIColor.white
        titlesScrollerView.contentSize = CGSize(width: titlesScrollerViewContentWidth, height: 40)
        titlesScrollerView.showsHorizontalScrollIndicator = false
        self.view.addSubview(titlesScrollerView)
        let titleButtonH = titlesScrollerView.height
        var titleX = CGFloat()
        for (i, name)in self.titleArray.enumerated() {
            let titleButton = UIButton()
            titleButton.setTitle(name, for: .normal)
            titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            titleButton.setTitleColor(UIColor.black, for: .normal)
            titleButton.backgroundColor = UIColor.white
            titleButton.height = titleButtonH
            titleButton.titleLabel?.textAlignment = .right
            titleButton.y = 0
            titleButton.addTarget(self, action: #selector(self.titleClick), for: .touchUpInside)
            titlesScrollerView.addSubview(titleButton)
            self.titleButtons.append(titleButton)
            let nameWidth = name.width(ScreenWidth, fontSize: 15)
            textWidthArray.append(nameWidth)
            titleButton.width = nameWidth + titleMargin
            switch i {
            case 0:
                titleX = 0
            default: // 把当前选中的按钮之前的按钮文字宽度都加起来
                titleX += textWidthArray[i-1]
            }
            titleButton.x = titleX + (CGFloat(i) * titleMargin)
        }
        titleBottomView.backgroundColor = UIColor.black
        titleBottomView.height = 3
        titleBottomView.y = titlesScrollerView.height - 3
        titlesScrollerView.addSubview(titleBottomView)
        
        guard let firstTitleButton = self.titleButtons.getElementAt(self.defaultIndex) else { return }
        firstTitleButton.titleLabel?.sizeToFit()
        titleBottomView.width = titleSlideBottomW
        titleBottomView.centerX = firstTitleButton.centerX
        self.titleClick(titleButton: firstTitleButton)
    }
    
    func setupScrollView() {
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        scrollView.frame = CGRect(x: 0, y: TopBarHeight + 40, width: ScreenWidth, height: ScreenHeight - TopBarHeight + 40)
        scrollView.backgroundColor = UIColor.white
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: CGFloat(self.childViewControllers.count) * ScreenWidth, height: 0)
        self.view.addSubview(scrollView)
        
        //         默认显示第self.defaultIndex个控制器
        var offset = self.scrollView.contentOffset
        offset.x = CGFloat(self.defaultIndex) * self.view.frame.width
        self.scrollView.setContentOffset(offset, animated: false)
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    @objc func titleClick(titleButton: UIButton) {
        // 控制按钮状态
        self.selectedTitleButton.isSelected = false
        titleButton.isSelected = true
        self.selectedTitleButton = titleButton
        // 底部控件的位置和尺寸
        UIView.animate(withDuration: 0.25) {
            self.titleBottomView.width = titleSlideBottomW
            self.titleBottomView.centerX = titleButton.centerX
        }
        // 让scrollView滚动到对应的位置
        var offset = self.scrollView.contentOffset
        guard let index = self.titleButtons.index(of: titleButton) else { return }
        for (i, button) in self.titleButtons.enumerated() {
            if i == index {
                button.titleLabel?.textAlignment = .right
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                button.setTitleColor(UIColor.black, for: .normal)
                button.setTitleColor(UIColor.black, for: .selected)
                button.backgroundColor = UIColor.white
            } else {
                button.titleLabel?.textAlignment = .right
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                button.setTitleColor(UIColor.black, for: .normal)
                button.setTitleColor(UIColor.black, for: .selected)
                button.backgroundColor = UIColor.white
            }
        }
        
        offset.x = self.view.frame.width * CGFloat(index)
        // scrollView偏移
        self.scrollView.setContentOffset(offset, animated: true)
        var offsetX = titleButton.center.x - self.titlesScrollerView.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        var maxOffsetX = titlesScrollerView.contentSize.width - self.titlesScrollerView.width
        if maxOffsetX < 0 {
            maxOffsetX = 0
        }
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        self.titlesScrollerView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    /**
     * 当滚动动画完毕的时候调用（通过代码setContentOffset:animated:让scrollView滚动完毕后，就会调用这个方法）
     * 如果执行完setContentOffset:animated:后，scrollView的偏移量并没有发生改变的话，就不会调用scrollViewDidEndScrollingAnimation:方法
     */
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 取出对应的子控制器
        let index: Int = Int((scrollView.contentOffset.x) / scrollView.frame.width)
        
        let willShowChildVc = self.childViewControllers.getElementAt(index)
        // 如果控制器的view已经被创建过，就直接返回
        if willShowChildVc?.isViewLoaded == true {
            if let _ = willShowChildVc as? WJJChildViewController{
                // 这里可以调子控制器的方法刷新自控制器数据
            }
            return
        } else {
            // 添加子控制器的view到scrollView身上
            willShowChildVc?.view.frame = scrollView.bounds
            scrollView.addSubview(willShowChildVc?.view ?? UIView())
        }
    }
    
    /**
     * 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            self.scrollViewDidEndScrollingAnimation(scrollView)
            let index: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
            self.titleClick(titleButton: self.titleButtons[index])
        }
    }
}

extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    /** 宽 */
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    /** 高 */
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    /** 竖直中心对齐 */
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    /** 水平中心对齐 */
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
}

extension String {
    
    public func width(_ maxWidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attribute = [NSAttributedStringKey.font: font]
        return self.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attribute, context: nil).size.width
    }
}

extension Array {
    
    func getElementAt(_ index: Int) -> Element? {
        if self.count > index {
            return self[index]
        }
        
        return nil
    }

}


