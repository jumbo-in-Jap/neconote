//
//  ViewController.swift
//  neconote
//
//  Created by 羽田 健太郎 on 2015/03/07.
//  Copyright (c) 2015年 羽田 健太郎. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var switchView:SwitchBase = SwitchBase.instance(CGRectMake(1000, 1000, 160,160))
    
    var types = [FloorType.Sofa, FloorType.Ricecooker, FloorType.Door, FloorType.Bathroom]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib( UINib(nibName: "FloorTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.view.addSubview(switchView)
        switchView.frame = CGRectMake(1000, 1000, 160,160)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FloorTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as FloorTableViewCell
        cell.type = types[indexPath.row]
        cell.floor = indexPath.row+1
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath:NSIndexPath!) {
        //self.switchView.change()
    }

}


