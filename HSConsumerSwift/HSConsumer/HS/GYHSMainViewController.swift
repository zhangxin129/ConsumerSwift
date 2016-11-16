//
//  GYHSMainViewController.swift
//  HSConsumer
//
//  Created by apple on 2016/10/31.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

class GYHSMainViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        
            super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.hidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.hidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor .whiteColor()
        
        let headView : UIView = UIView(frame : CGRectMake(0,0,self.view.frame.size.width,150))
        
        headView.backgroundColor = UIColor .blueColor()
        
        self.view .addSubview(headView)
        
        
        let imgArray : Array<String> = ["gyhs_sweep_code_pay","gyhs_payment_code","gyhs_integral_code","gyhs _exchange_hsb"]
        
        let titleArray : Array<String> = ["扫码付","支付码","积分码","兑换互生币"]
        
        let labelArray : Array<String> = ["扫商家收款码","互生币支付","互生卡二维码","用于互生币支付"]
        
        let distance_x : CGFloat = (self.view.frame.size.width - 160 - 40)/3
        
        let dis_x : CGFloat = (self.view.frame.size.width - 240 - 20)/3
        
        
        for i in 0...3 {
            
            let mainBtn : UIButton = UIButton(type : UIButtonType.Custom)
            
            mainBtn.frame = CGRectMake(20 + CGFloat(i) * (40 + distance_x), 44, 50, 50)
            
            mainBtn .setBackgroundImage(UIImage (named: imgArray[i]), forState: UIControlState.Normal)
            
            mainBtn .setTitle(titleArray[i], forState: UIControlState.Normal)
            
            mainBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0)
            
            mainBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -70, 0)
            
            mainBtn.titleLabel?.font = UIFont .systemFontOfSize(10.0)
            
            mainBtn .setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            mainBtn .setTitleColor(UIColor .yellowColor(), forState: UIControlState.Selected)
            
            mainBtn .addTarget(self, action:#selector(GYHSMainViewController.btnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            mainBtn.tag = i + 100
            
            self.view .addSubview(mainBtn)
            
            let mainLabel : UILabel = UILabel(frame : CGRectMake(15 + CGFloat(i) * (60 + dis_x), CGRectGetMaxY(mainBtn.frame)+10, 60, 40))
            
            mainLabel.text = labelArray[i]
            
            mainLabel.textColor = UIColor .whiteColor()
            
            mainLabel.textAlignment = NSTextAlignment.Center
            
            mainLabel.font = UIFont .systemFontOfSize(10.0)
            
            self.view .addSubview(mainLabel)
            
        }
        
        
        
        
    }
    
    func btnClick(sender : UIButton){
    
        
        for i in 0...3 {
            
            let  btn : UIButton =  self.view .viewWithTag(100+i) as! UIButton
            
            btn.selected = false
            
        }
        
        let btn =  self.view .viewWithTag(sender.tag) as? UIButton
        
        btn!.selected = true
        
        switch sender.tag {
        case 100:
            
            print(sender.tag)
            
        case 101:
            
             print(sender.tag)
            
        case 102:
            
             print(sender.tag)
            
        case 103:
            
             print(sender.tag)
            
        default:
             print("others")
            
        }
        

        
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
