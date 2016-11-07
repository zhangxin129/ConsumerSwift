//
//  GYHEVisitSurroundViewController.swift
//  HSConsumer
//
//  Created by apple on 2016/10/31.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

class GYHEVisitSurroundViewController: UIViewController,UITextFieldDelegate {
    
    
    var searchTF : UITextField?
    
    
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
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) -> Void {
        
        textField.enabled = false
        
        let ctl = UIViewController()
        
        ctl.view.backgroundColor = UIColor .redColor()
        
        self.navigationController!.pushViewController(ctl, animated: true)
        
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
