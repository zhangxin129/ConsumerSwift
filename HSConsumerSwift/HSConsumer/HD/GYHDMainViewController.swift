//
//  GYHDMainViewController.swift
//  HSConsumer
//
//  Created by apple on 2016/10/31.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

class message: AnyObject {
    
    var icon : String?
    
    var name : String?
    
    var content : String?
    
    var time : String?
    
}


class GYHDMainViewController: UIViewController,DrawerMenuControllerDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var messageTableView :UITableView?
    
    var dataArray : Array<message> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.view.backgroundColor = UIColor .lightGrayColor()
        
        let headBtn = UIButton( type : UIButtonType.Custom)
        
        headBtn .setImage(UIImage (named: "gyhd_defaultheadimg"), forState: UIControlState.Normal)
        
        headBtn.layer.cornerRadius = 15
        
        headBtn.layer.masksToBounds = true
        
        headBtn .addTarget(self, action:#selector(GYHDMainViewController.headClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        headBtn.frame = CGRectMake(0, 0, 30, 30)
        
        let headItem = UIBarButtonItem(customView : headBtn)
        
        self.navigationItem.leftBarButtonItem = headItem
        
        let contactsBtn = UIButton(type : UIButtonType.Custom)
        
        contactsBtn .setImage(UIImage (named: "gyhd_contants_icon"), forState: UIControlState.Normal)
        
        contactsBtn.frame = CGRectMake(0, 0, 40, 40)
        
        let contactsItem = UIBarButtonItem(customView : contactsBtn)

        let addBtn = UIButton(type : UIButtonType.Custom)
        
        addBtn .setImage(UIImage (named: "gyhd_main_add_icon"), forState: UIControlState.Normal)
        
        addBtn.frame = CGRectMake(0, 0, 40, 40)
        
        let addItem = UIBarButtonItem(customView : addBtn)
        
        self.navigationItem.rightBarButtonItems = [addItem,contactsItem]
        
        self.navigationController?.navigationBar.barTintColor = UIColor .redColor()
        
        self .setupTabelView()
        
        self .loadMessageList()
        
    }
    
//    MARK: 左侧视图划出事件
    func headClick() -> Void {
        
          (UIApplication.sharedApplication().delegate as! AppDelegate).drawerMenuController?.showLeftViewController(true)
    }
    
    func setupTabelView() -> Void {
        
        self.messageTableView = UITableView(frame: self.view.frame, style : UITableViewStyle.Plain)
        
        self.messageTableView!.delegate = self
        
        self.messageTableView!.dataSource = self
        
        self.messageTableView?.rowHeight = 88
        
        self.messageTableView!.registerClass(MessageMainTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view .addSubview(self.messageTableView!)
        
        
        
    }
    
    
//    MARK: 加载数据
    
    func loadMessageList() -> Void {
        
        
        for a in 1...10 {
            
            let mes = message()
            
            mes.icon = "gyhd_defaultheadimg"
            
            mes.name = "好友\(a)号"
            
            mes.content = "哈哈哈哈哈"
            
            let formatter = NSDateFormatter()
            
            formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            
           let timeInterval:NSTimeInterval = NSDate().timeIntervalSince1970
            
           let date = NSDate(timeIntervalSince1970: timeInterval)
            
            mes.time = formatter.stringFromDate(date)
            
            self.dataArray .append(mes)
            
        }
        
        self.messageTableView!.reloadData()
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView .dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MessageMainTableViewCell
        
        var mes = message()
        
        mes = self.dataArray[indexPath.row]
        
        cell.mes = mes
        
        return cell
    }
    

}
