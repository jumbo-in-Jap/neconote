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
        }
    }
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
        if selected{
            cat.status = .walk
        }
    }
    
    
}
