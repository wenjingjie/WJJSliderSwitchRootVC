//
//  WJJChildViewController.swift
//  WJJSliderSwitch
//
//  Created by wenjingjie on 2018/8/10.
//  Copyright © 2018年 wjj. All rights reserved.
//

import UIKit

class WJJChildViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.random()
    }
    
}

extension UIColor {
    /// 随机颜色
    static func random() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0,
                       green: CGFloat(arc4random_uniform(256)) / 255.0,
                       blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1.0)
    }
}
