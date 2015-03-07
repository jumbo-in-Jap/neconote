//
//  CatView.swift
//  neconote
//
//  Created by 羽田 健太郎 on 2015/03/07.
//  Copyright (c) 2015年 羽田 健太郎. All rights reserved.
//

import UIKit

enum CatAnimationType{
    case walk
    case sit
    case back
    case sleep
}
class CatView: UIView {
    
    @IBOutlet weak var catImage: UIImageView!
    var status:CatAnimationType = .sit{
        didSet{
        }
    }
    // 階層をセットしたらnekoが出る
    // ここから動き始める
    var floor:Int = 0{
        didSet{
            // nekoの初期位置
            // y > 20
            if (floor == 1){
                self.frame = CGRectMake(
                    100,
                    20,
                    self.frame.size.width,
                    self.frame.size.height)
            }else if(floor == 2){
                self.frame = CGRectMake(
                    150,
                    35,
                    self.frame.size.width,
                    self.frame.size.height)
                self.status = .sleep
            }else if(floor == 3){
                self.frame = CGRectMake(
                    80,
                    20,
                    self.frame.size.width,
                    self.frame.size.height)
            }else if(floor == 4){
                self.frame = CGRectMake(
                    200,
                    30,
                    self.frame.size.width,
                    self.frame.size.height)
            }
            self.startAnimation()
        }
    }
    
    func back(notification: NSNotification?) {
        if let userInfo = notification?.userInfo
        {
            if self.floor == userInfo["floor"] as Int{
                self.status = .back
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "back:", name: "back_cat", object: nil)
    }
    
    class func instance(frame:CGRect) -> CatView {
        var view:CatView =  UINib(nibName: "CatView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as CatView
        return view
    }
    
    func startAnimation(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
            while (true){
                switch (self.status){
                case .walk: self.animation(String(format:"fl%d_neco_walk",self.floor), start_ctn: 1, end_ctn: 4)
                case .sit:  self.animation(String(format:"fl%d_neco_sitdown",self.floor), start_ctn: 1, end_ctn: 2)
                case .back:  self.animation(String(format:"fl%d_neco_walk",self.floor), start_ctn: 1, end_ctn: 4)
                case .sleep:  self.animation(String(format:"fl%d_neco_sleep",self.floor), start_ctn: 1, end_ctn: 2)
                default :break
                }
            }
        })
    }
    
    func animation(prefix:String, start_ctn:Int, end_ctn:Int){
        for (var i=start_ctn;i<=end_ctn;i++)
        {
            var img_name = String(format: "%@%d", prefix, i)
            let delay = 0.8 * Double(NSEC_PER_SEC)
            dispatch_async(dispatch_get_main_queue(), {
                self.catImage.image = UIImage(named: img_name)
                // walkなら画像の更新だけでなく座標も動かす
                if(self.status == .walk)
                {
                    self.catImage.transform = CGAffineTransformMakeScale(1, 1)
                    self.toGoal(16.0)
                }else if(self.status == .back){
                    self.catImage.transform = CGAffineTransformMakeScale(-1, 1)
                    self.toBack(16.0)
                }
            })
            
            NSThread.sleepForTimeInterval(self.getRandomNumber(Min: 0.5, Max: 0.6))
        }
    }
    
    // 呼ぶたびにすこしずつゴールに近ずける
    func toGoal(walkDist:CGFloat){
        // 進むピクセルのみ指定
        var x0:CGFloat = self.frame.origin.x
        var y0:CGFloat = self.frame.origin.y
        var x1:CGFloat = 45
        var y1:CGFloat = 25
        var delta = atan((y1-y0)/x1-x0)
        var x_:CGFloat = 0
        var y_:CGFloat = 0
        
        if(y1>y0){
            y_ = y0 + walkDist
        }else{
            y_ = y0 - walkDist
        }
        if(abs(y1-y0) < walkDist){
            y_ = y1
        }
        
        x_ = x0 - walkDist
        if(abs(x1-x0) < walkDist){
            x_ = x1
        }
        
        if (x_ == x1 && y_ == y1){
            self.status = .sit
            NSNotificationCenter.defaultCenter().postNotificationName("goal_cat", object: nil, userInfo: ["floor":self.floor])
        }
        self.frame = CGRectMake(x_, y_, self.frame.size.width, self.frame.size.height)
    }
    
    
    func getRandomNumber(Min _Min : Float, Max _Max : Float)->NSTimeInterval {
        return NSTimeInterval(( Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX) ) * (_Max - _Min) + _Min)
    }
    
    func toBack(walkDist:CGFloat)
    {
        var x_ = self.frame.origin.x + walkDist
        if(abs(100-x_) < walkDist){
            x_ = 100
        }
        if( x_ == 100){
            self.status = .sit
        }

        self.frame = CGRectMake(x_, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
    }
}
