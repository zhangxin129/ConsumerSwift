//
//  DrawerMenuExplain.swift
//  DrawerMenuController Controller
//
//  Created by SunSet on 14-7-18.
//  Copyright (c) 2014年 zhaokaiyuan. All rights reserved.
// qq 623046455 邮箱 zhaokaiyuan99@163.com

import UIKit
import QuartzCore
//自定义 侧滑
//
class CustomMenuController: DrawerMenuController {
    
    //
    override func layoutCurrentViewWithOffset(xoffset: CGFloat) {
        super.layoutCurrentViewWithOffset(xoffset)
        if xoffset > 0 {
            leftSideView!.frame = CGRectMake( ( -leftSideView!.frame.size.width + xoffset +  xoffset / self.leftViewShowWidth * ( leftSideView!.frame.size.width - xoffset) ) , 0, leftSideView!.frame.size.width, leftSideView!.frame.size.height)
            leftSideView!.alpha = xoffset/self.leftViewShowWidth
        }
    }
    // MARK: - 显示左加载
    override func showLeftViewController(animated: Bool) {
        
        super.showLeftViewController(true)
        
    }
//    MARK: -  显示右视图
    override func showRightViewController(animated: Bool) {
        super.showRightViewController(true)
    }
    
    override func hideSideViewController(animated: Bool) {
        
        UIView.animateWithDuration(0.3, animations: {
            var newFrame:CGRect =  self.mainContentView!.frame
            if newFrame.origin.x < 0 {
                newFrame.origin.x  =  newFrame.origin.x - 30
            }else {
                newFrame.origin.x  =  newFrame.origin.x + 30
            }
            
            self.mainContentView!.frame = newFrame
            }, completion: {
                (finish:Bool) -> Void in
                self.close()
        })
        
        
        //super.hideSideViewController(true)
        
    }
    
    func close(){
        super.hideSideViewController(true)
    }
    
    
    
    
    
}