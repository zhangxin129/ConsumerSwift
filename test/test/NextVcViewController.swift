//
//  NextVcViewController.swift
//  test
//
//  Created by apple on 2016/10/29.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

var title : String?

class person {
    
    var man :String?
    
    var kid : String?
    
}

typealias returnBlcok = (String) -> Void

typealias blcok = () -> Void

typealias returnB = (String) -> String

protocol NextVcViewControllerDelegate : NSObjectProtocol{
    
    func refrsh(a : String)
    
}

class NextVcViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var data : Array<person>? = []
    
    var tableView :UITableView?
    
    var delegate : NextVcViewControllerDelegate?
    
    var returnBlock : returnBlcok?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor .yellowColor()
        
        self.tableView = UITableView(frame:self.view.frame,style : UITableViewStyle.Grouped)
        
        self.tableView!.delegate = self
        
        self.tableView!.dataSource = self
        
        self.tableView!.rowHeight = 40

        self.tableView! .registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view .addSubview(self.tableView!)

        self .loadData()
        
        
    }
    
    func loadData() -> Void {

        for a in 1...10 {
            
            let per = person()
            
            per.kid = "wangbiao"
            
            per.man =  "jingguang\(a)"
            
            self.data!.append(per)
        }

        self.tableView! .reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.data!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let  cell =  tableView .dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as UITableViewCell
        
        var p = person()
        

        p = self.data![indexPath.row]
        
        cell.textLabel?.text = p.man
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        var p = person()
        
        
        p = self.data![indexPath.row]
        
//        if (self.delegate) != nil {
//            
//            self.delegate!.refrsh(p.man!)
//        }
        
        
        if (self.returnBlock) != nil {
            
            self.returnBlock!(p.man!)
        }
        
        self .navigationController!.popViewControllerAnimated(true)

        
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
