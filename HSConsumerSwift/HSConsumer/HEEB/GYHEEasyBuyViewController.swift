//
//  GYHEEasyBuyViewController.swift
//  HSConsumer
//
//  Created by apple on 2016/10/31.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit


class detail {
    
    var title : String?
    
    var datas : Array<catogray> = []
}


class catogray {
    
    var icon : String?
    
    var title : String?
    
    var select : Bool?
    
}

class GYHEEasyBuyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    var tableView : UITableView?
    
    var colletionView :  UICollectionView?
    
    var tableViewDataArray :Array<catogray> = []
    
    var collectionDataArray : Array<detail> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor .whiteColor()
        
        let shopingCarBtn : UIButton = UIButton(type : UIButtonType.Custom)
        
        shopingCarBtn.frame = CGRectMake(0, 0, 40, 40)
        
        shopingCarBtn .setImage(UIImage (named: "gyhe_goods_shop_car"), forState: UIControlState.Normal)
        
        let shopingCarItem : UIBarButtonItem = UIBarButtonItem(customView : shopingCarBtn)
        
        let searchBtn : UIButton =  UIButton(type : UIButtonType.Custom)
        
        searchBtn.frame = CGRectMake(0, 0, 150, 40)
        
        searchBtn .setTitle("搜索", forState: UIControlState.Normal)
        
        searchBtn .setTitleColor(UIColor .grayColor(), forState: UIControlState.Normal)
        
        searchBtn.backgroundColor = UIColor .lightGrayColor()
        
        searchBtn .contentEdgeInsets = UIEdgeInsetsMake(0, -100, 0, 0)
        
        searchBtn .setImage(UIImage (named: "gyhd_search_icon"), forState: UIControlState.Normal)
        
        let searchItem : UIBarButtonItem =  UIBarButtonItem(customView : searchBtn)
        
        self.navigationItem.rightBarButtonItems = [shopingCarItem,searchItem]
        
        self .setupTableView()
        
        self .setupCollectionView()
    }
    
    
    
    func setupTableView() {
        
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, 100, self.view.frame.size.height),style : UITableViewStyle.Plain)
        
        
        self.tableView?.delegate = self
        
        self.tableView?.dataSource = self
        
        self.tableView?.rowHeight = 80
        
        self.tableView!.registerClass(GYHEEBMainTableViewCell.self, forCellReuseIdentifier: "GYHEEBMainTableViewCell")
        
        self.view .addSubview(self.tableView!)
        
        for _ in 0...10 {
            
            let catograyModel = catogray()
            
            catograyModel.title = "分类标题"
            
            catograyModel.icon = "gycommon_pv"
            
            catograyModel.select = false
            
            self.tableViewDataArray .append(catograyModel)
            
        }
        
        self.tableView!.reloadData()
    
    }
    
    
    func setupCollectionView()  {
        
        let layOut = UICollectionViewFlowLayout()
        
            layOut.itemSize = CGSizeMake(60, 80)
        
        layOut.minimumLineSpacing = 10.0  //上下间隔
        layOut.minimumInteritemSpacing = 5.0 //左右间隔
        layOut.headerReferenceSize = CGSizeMake(20, 40)
        
        layOut.scrollDirection = UICollectionViewScrollDirection.Vertical  //滚动
        
        self.colletionView = UICollectionView(frame: CGRectMake(CGRectGetMaxX(self.tableView!.frame),64, self.view.frame.size.width-CGRectGetMaxX(self.tableView!.frame), self.view.frame.size.height-113),collectionViewLayout : layOut)
        
        self.colletionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.colletionView!.registerClass(GYHEEBHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        self.colletionView?.backgroundColor = UIColor .whiteColor()
        
        self.colletionView?.delegate = self
        
        self.colletionView?.dataSource = self
        
        self.view .addSubview(self.colletionView!)
        
    
        for i in 0...2 {
        
            let model = detail()
            
            model.title = "分类\(i)组"
            
            for j in 0...10 {
                
                let catogaryModel = catogray()
                
                catogaryModel.icon = "gycommon_pv"
                
                catogaryModel.title = "小类标题\(j)"
                
                model.datas .append(catogaryModel)
                
            }
            self.collectionDataArray .append(model)
            
        }
        
        self.colletionView!.reloadData()
    }
    
    
//    MARK: tabelViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tableViewDataArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : GYHEEBMainTableViewCell = tableView .dequeueReusableCellWithIdentifier("GYHEEBMainTableViewCell") as!GYHEEBMainTableViewCell
        
        let model :catogray = self.tableViewDataArray[indexPath.row]
        
        cell.model = model
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        for tempModel : catogray in self.tableViewDataArray {
            
                tempModel.select = false
            
        }
        
        let model :catogray = self.tableViewDataArray[indexPath.row]
        
        model.select = true
        
        self.tableView!.reloadData()
    }
    
//    MARK:collectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let model : detail = self.collectionDataArray[section]
    
        return model.datas.count
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return self.collectionDataArray.count
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : UICollectionViewCell = (colletionView?.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath))!
        
        cell.backgroundColor = UIColor .orangeColor()
        
        return cell
        
    }
    
    //实现UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //某个Cell被选择的事件处理
    }

//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//        
//        
//        
//    }
    

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
