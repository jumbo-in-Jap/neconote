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
    case jump
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
                    25,
                    self.frame.size.width,
                    self.frame.size.height)
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
    
    override func drawRect(rect: CGRect) {
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
            })
            
            // walkなら画像の更新だけでなく座標も動かす
            if(self.status == .walk)
            {
                
            }
            NSThread.sleepForTimeInterval(self.getRandomNumber(Min: 0.5, Max: 0.6))
        }
    }
    
    // 呼ぶたびにすこしずつゴールに近ずける
    func toGoal(walkDist:CGFloat){
        // 進むピクセルのみ指定
        var x0 = self.frame.origin.x
        var y0 = self.frame.origin.y
        var x1 = 45
        var y1 = 25
        //var res = atan((y1-y0)/x1-x0)
    }

    
    func getRandomNumber(Min _Min : Float, Max _Max : Float)->NSTimeInterval {
        return NSTimeInterval(( Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX) ) * (_Max - _Min) + _Min)
    }

}
