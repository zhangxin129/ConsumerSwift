//
//  GYHEVisitSurroundViewController.swift
//  HSConsumer
//
//  Created by apple on 2016/10/31.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

class GYHEVisitSurroundViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    var searchTF : UITextField?
    
    var tableView : UITableView?
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = UIColor .orangeColor()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.searchTF?.enabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor .lightGrayColor()
        
        self.searchTF = UITextField(frame : CGRectMake(0, 0, 200, 30))
        
            self.searchTF!.borderStyle = UITextBorderStyle.RoundedRect
        
        self.searchTF!.text = "搜索"
        
        self.searchTF!.textColor = UIColor .whiteColor()
        
        self.searchTF!.backgroundColor = UIColor .brownColor()
        
        let leftView = UIImageView(frame : CGRectMake(10, 2, 20,20))
        
            leftView.image = UIImage (named: "gyhe_food_search")
        
        self.searchTF!.leftView = leftView
        
        self.searchTF!.leftViewMode = UITextFieldViewMode.Always

        self.searchTF!.delegate = self
        
        self.navigationItem.titleView = searchTF
        
        let rightBtn = UIButton(type : UIButtonType.Custom)
        
            rightBtn.frame = CGRectMake(0, 0, 30, 30)
        
            rightBtn .setImage(UIImage (named: "gycommon_nav_cart"), forState: UIControlState.Normal)
        
       let  rightItem = UIBarButtonItem(customView : rightBtn)
        
        self.navigationItem.rightBarButtonItem = rightItem
        

        let leftBtn = UIButton(type : UIButtonType.Custom)
        
        leftBtn.frame = CGRectMake(0, 0, 40, 40)
        
        leftBtn .setTitle("深圳", forState: UIControlState.Normal)
        
        let  leftItem = UIBarButtonItem(customView : leftBtn)
        
        self.navigationItem.leftBarButtonItem = leftItem
        
        self .setupTabelView()
    }
    
    
    func setupTabelView(){
        
        let tableHeadView = UIView()
        
        tableHeadView.frame = CGRectMake(0, 0, self.view.frame.size.width, 230)
        
        tableHeadView.backgroundColor = UIColor .lightGrayColor()
        
        let distance_x : CGFloat = (self.view.frame.size.width - 180)/4
        
        let with : CGFloat = 60
        
        let heigh : CGFloat = 60
        
        let titleArr : Array<String> = ["附近","餐饮","生活服务","休闲娱乐","旅游酒店","房产"]
        
        
        for row in 0...1 {
            
            for column in 0...2 {
                
                let imgView : UIImageView = UIImageView(frame : CGRectMake(distance_x + (distance_x + with) * CGFloat(column) , (20 + 90) * CGFloat(row) + 10  , with, heigh))
                
                imgView.tag = column + row * 3 + 1
                
                imgView.layer.cornerRadius = 30
                
                imgView.layer.masksToBounds = true
                
                let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(GYHEVisitSurroundViewController.imgTap(_:)))
                
                imgView.userInteractionEnabled = true
                
                imgView .addGestureRecognizer(tap)
                
                imgView.backgroundColor = UIColor .redColor()
                
                tableHeadView .addSubview(imgView)
                
                let titleLabel : UILabel = UILabel(frame : CGRectMake(distance_x + (distance_x + with) * CGFloat(column) , CGRectGetMaxY(imgView.frame) , 60, 30))
                
                titleLabel.text = titleArr[column + row * 3]
                
                titleLabel.font = UIFont .systemFontOfSize(14)
                
                titleLabel.textAlignment = NSTextAlignment.Center
                
                tableHeadView .addSubview(titleLabel)
                
                
            }
            
        }
        
        
        self.tableView = UITableView(frame: self.view.frame,style: UITableViewStyle.Plain)
        
        self.tableView?.delegate = self
        
        self.tableView?.dataSource = self
        
        self.tableView?.tableHeaderView = tableHeadView
        
        self.tableView!.registerClass(GYHESRMainTableViewCell.self, forCellReuseIdentifier: "GYHESRMainTableViewCell")
        
         self.tableView!.registerClass(GYHESRTakeOutTableViewCell.self, forCellReuseIdentifier: "GYHESRTakeOutTableViewCell")
        
        self.view .addSubview(self.tableView!)
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var baseCell : UITableViewCell? = UITableViewCell()
        
        if indexPath.section == 0 {
            
            var cell = GYHESRMainTableViewCell()
            
            cell = tableView.dequeueReusableCellWithIdentifier("GYHESRMainTableViewCell") as! GYHESRMainTableViewCell
            
            
           baseCell =  cell
            
        }else{
            
            var cell = GYHESRTakeOutTableViewCell()
            
            cell = tableView.dequeueReusableCellWithIdentifier("GYHESRTakeOutTableViewCell") as! GYHESRTakeOutTableViewCell
            
            baseCell =  cell
        
        }
        
        baseCell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return baseCell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 20
    }

    func textFieldDidBeginEditing(textField: UITextField) -> Void {
        
        textField.enabled = false
        
        let ctl = UIViewController()
        
        ctl.view.backgroundColor = UIColor .redColor()
    
        ctl.title = "搜索"
        
        self.navigationController!.pushViewController(ctl, animated: true)
        
            print("搜索")
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 100
            
        }
        
        return  170
    }
    
    
    func imgTap(sender:UITapGestureRecognizer) {
        
        print(sender.view?.tag)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
