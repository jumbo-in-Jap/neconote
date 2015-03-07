//
//  FloorTableViewCell.swift
//  neconote
//
//  Created by 羽田 健太郎 on 2015/03/07.
//  Copyright (c) 2015年 羽田 健太郎. All rights reserved.
//

import UIKit
enum FloorType {
    case Sofa
    case Ricecooker
    case Bathroom
    case Door
}


class FloorTableViewCell: UITableViewCell {
    @IBOutlet weak var bgView: UIImageView!
    var cat:CatView = CatView.instance(CGRectMake(100, 120, 50, 50))
    var floor:Int = 0{
        didSet{
            self.cat.floor = floor
            self.bgView.image = UIImage(named: String(format:"fl%d_bg", floor))
            self.setItem(floor)
        }
    }
    var item:UIImageView!
    var type:FloorType = .Sofa{
        didSet{
            switch type {
            case .Sofa:
                self.bgView.image = UIImage(named: "fl1_bg")
            case .Ricecooker:
                self.bgView.image = UIImage(named: "fl2_bg")
            case .Bathroom:
                self.bgView.image = UIImage(named: "fl3_bg")
            case .Door:
                self.bgView.image = UIImage(named: "fl4_bg")
            case .Door:
                self.bgView.image = UIImage(named: "fl4_bg")
            default:
                break // do nothing
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectionStyle = .None
        self.type = FloorType.Sofa
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "on_item:", name: "back_cat", object: nil)
    }
    
    override init() {
        super.init()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addSubview(cat)
        self.cat.frame = CGRectMake(100, 20, 95,95)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected && floor != 2{
            cat.status = .walk
        }
    }
    
    func setItem(type:Int){
        if(type == 1){
            item = UIImageView(image: UIImage(named: "fl1_door_off"))
            item.contentMode = UIViewContentMode.ScaleAspectFill
            item.frame = CGRectMake(30, 25, 40, 40)
            self.addSubview(item)
        }else if(type == 2){
            
        }else if(type == 3){
            item = UIImageView(image: UIImage(named: "fl3_bath_off"))
            item.contentMode = UIViewContentMode.ScaleAspectFill
            item.frame = CGRectMake(30, 50, 40, 40)
            self.addSubview(item)
        }else if(type == 4){
            item = UIImageView(image: UIImage(named: "btn_rice_off"))
            item.contentMode = UIViewContentMode.ScaleAspectFill
            item.frame = CGRectMake(40, 30, 30, 30)
            self.addSubview(item)
        }else if(type == 5){
            item = UIImageView(image: UIImage(named: "btn_light_off"))
            item.contentMode = UIViewContentMode.ScaleAspectFill
            item.frame = CGRectMake(35, 0, 30, 30)
            self.addSubview(item)
        }
        self.bringSubviewToFront(self.cat)
    }
    
    func on_item(notification: NSNotification?) {
        if let userInfo = notification?.userInfo
        {
            if self.floor != userInfo["floor"] as Int{
                return
            }
        }
        if(self.floor == 1){
            item.image = UIImage(named: "fl1_door_on")
        }else if(self.floor == 2){
            
        }else if(self.floor == 3){
            item.image = UIImage(named: "fl3_bath_on")
        }else if(self.floor == 4){
            item.image = UIImage(named: "btn_rice_on")
        }else if(self.floor == 5){
            item.image = UIImage(named: "btn_light_on")
        }
    }
    
}
