//
//  ViewController.swift
//  test
//
//  Created by apple on 2016/10/29.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

class ViewController: UIViewController,NextVcViewControllerDelegate{
    
    var clickBtn : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor .redColor()
        
       self.clickBtn  = UIButton (type : UIButtonType.Custom)
        
        self.title = "next"
        
         self.clickBtn! .setTitle("click", forState: UIControlState.Normal)
        
        self.clickBtn?.titleLabel?.textAlignment = NSTextAlignment.Center
        
         self.clickBtn!.frame = CGRectMake(self.view.frame.size.width/2-50, 300, 100, 40)
        
         self.clickBtn! .setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
         self.clickBtn!.backgroundColor = UIColor .yellowColor()
        
         self.clickBtn! .addTarget(self, action: #selector(ViewController.click), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view .addSubview(self.clickBtn!)

        
        self .loadData("Hello")
    }
    
    
    func loadData(a : String) -> Void {
        
        print(a +  "World")
        
    }
    
    
    func click() -> Void {
        
        
        let vc = NextVcViewController()
        
        vc.title = "two"
        
        vc.delegate = self
        
        vc.returnBlock = {
        
            (backStr : String) -> Void in
            
            
        self.clickBtn!.setTitle(backStr, forState: UIControlState.Normal)
            
        }
        
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func refrsh(a: String) {
        
        self.clickBtn!.setTitle(a, forState: UIControlState.Normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

