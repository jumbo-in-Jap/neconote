//
//  SwitchBase.swift
//  neconote
//
//  Created by 羽田 健太郎 on 2015/03/07.
//  Copyright (c) 2015年 羽田 健太郎. All rights reserved.
//

import UIKit
import AudioToolbox

class SwitchBase: UIView {

    var showFlag = false
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var switchImage: UIImageView!
    @IBOutlet weak var necohand:UIImageView!
    var floor:Int = 1{
        didSet{
            self.necohand.image = UIImage(named: String(format: "btn_te_fl%d", self.floor))
        }
    }
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

    func completeAnimation(){}
    
    func show(){
//        NeconoteBLE.shared().findWithName("2", ready: {()->Void in
            self.switchImage.image = UIImage(named: "btn_off")
            self.frame = CGRectMake(
                (UIScreen.mainScreen().bounds.width - 160)/2,
                UIScreen.mainScreen().bounds.height - 180,
                self.frame.width, self.frame.height)
            
            UIView.animateWithDuration(0.7,
                animations: {() -> Void in
                    self.alpha = 1.0
                }, completion: {(Bool) -> Void in
                    self.showHand(self.floor)
            })
//        })
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
    
    
    
    
    func showHand(floor:Int)
    {
        // Load
        let soundURL = NSBundle.mainBundle().URLForResource("cat3", withExtension: "mp3")
        var mySound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL, &mySound)
        AudioServicesPlaySystemSound(mySound)
        
        UIView.animateWithDuration(0.8,
            animations: {() -> Void in
                self.necohand.frame = CGRectMake(
                    self.frame.size.width/2,
                    self.frame.size.height/2,
                    self.necohand.frame.width,
                    self.necohand.frame.height)
            }, completion: {(Bool) -> Void in
                //NeconoteBLE.shared().toggle({(res)->Void in })
                self.switchImage.image = UIImage(named: "btn_on")
                self.hide()
                //NeconoteBLE.shared().disconnect()
                NSNotificationCenter.defaultCenter().postNotificationName("back_cat", object: nil, userInfo: ["floor":floor])
        })
    }
}
