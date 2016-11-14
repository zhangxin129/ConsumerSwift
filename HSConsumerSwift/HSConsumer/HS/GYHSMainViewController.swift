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
        
        let distance_x : CGFloat = (self.view.frame.size.width - 240 - 40)/3
        
        
        for i in 0...3 {
            
            let mainBtn : UIButton = UIButton(type : UIButtonType.Custom)
            
            mainBtn.frame = CGRectMake(20 + CGFloat(i) * (60 + distance_x), 60, 60, 60)
            
            mainBtn .setImage(UIImage (named: imgArray[i]), forState: UIControlState.Normal)
            
            mainBtn .setTitle(titleArray[i], forState: UIControlState.Normal)
            
            mainBtn .setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            mainBtn .setTitleColor(UIColor .yellowColor(), forState: UIControlState.Selected)
            
            self.view .addSubview(mainBtn)
            
            
        }
        
        
        
        
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
