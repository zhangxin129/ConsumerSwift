//
//  GYHEVisitSurroundViewController.swift
//  HSConsumer
//
//  Created by apple on 2016/10/31.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

class GYHEVisitSurroundViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = UIColor .orangeColor()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor .lightGrayColor()
        
        let searchTF = UITextField(frame : CGRectMake(0, 0, 200, 30))
        
            searchTF.borderStyle = UITextBorderStyle.RoundedRect
        
        searchTF.text = "搜索"
        
        searchTF.textColor = UIColor .whiteColor()
        
        searchTF.backgroundColor = UIColor .brownColor()
        
        let leftView = UIImageView(frame : CGRectMake(10, 2, 20,20))
        
            leftView.image = UIImage (named: "gyhe_food_search")
        
        searchTF.leftView = leftView
        
        searchTF.leftViewMode = UITextFieldViewMode.Always
        
        self.navigationItem.titleView = searchTF
        
    }
    
    func searchAction() -> Void {
        
        print("搜索")
        
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
