//
//  MyImageView.swift
//  WJFanFanGameDemo
//
//  Created by jh navi on 15/9/17.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

import UIKit

class MyImageView: UIImageView {
    var myImage: UIImage?
    var myTag: NSInteger?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
    }
    
    func turn2Left() {
        UIView.transitionWithView(self, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, animations: { () -> Void in
            self.image = self.myImage
        }) { (Bool finished) -> Void in
            //水果状态时,不可点击
            self.userInteractionEnabled = false
        }
    }
    
    func turn2Right() {
        UIView.transitionWithView(self, duration: 0.5, options: .TransitionFlipFromRight, animations: { () -> Void in
            self.image = UIImage(named: "contrary.png")
        }) { (Bool finished) -> Void in
            //问号状态时可点击
            self.userInteractionEnabled = true
        }
    }
}
