//
//  SwitchBase.swift
//  neconote
//
//  Created by 羽田 健太郎 on 2015/03/07.
//  Copyright (c) 2015年 羽田 健太郎. All rights reserved.
//

import UIKit

class SwitchBase: UIView {

    var showFlag = false
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 5.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.3
    }
    
    class func instance(frame:CGRect) -> SwitchBase {
        var view:SwitchBase =  UINib(nibName: "SwitchBase", bundle: nil).instantiateWithOwner(self, options: nil)[0] as SwitchBase
        return view
    }
    
    func change(){
        showFlag ? self.hide() : self.show()
        showFlag = !showFlag
    }
    
    func show(){
        self.frame = CGRectMake(
            (UIScreen.mainScreen().bounds.width - 160)/2,
            UIScreen.mainScreen().bounds.height - 180,
            self.frame.width, self.frame.height)
        
        UIView.animateWithDuration(0.3,
            animations: {() -> Void in
                self.alpha = 1.0
            }, completion: {(Bool) -> Void in
        })
    }

    func hide(){
        
        UIView.animateWithDuration(0.2,
            animations: {() -> Void in
                self.alpha = 0.0
            }, completion: {(Bool) -> Void in
                self.frame = CGRectMake(
                    (UIScreen.mainScreen().bounds.width - 160)/2,
                    UIScreen.mainScreen().bounds.height,
                    self.frame.width, self.frame.height)
        })
    }
}
