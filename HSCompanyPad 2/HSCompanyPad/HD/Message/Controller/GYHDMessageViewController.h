//
//  GYHDMessageViewController.h
//  HSCompanyPad
//
//  Created by shiang on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"
/**
 *    @业务标题 : 主消息列表
 *
 *    @Created :  zhangx
 *    @Modify  : 1.
 *               2.
 *               3.
 */
#import "GYHDMainViewController.h"
@protocol GYHDMessageViewControllerDelegate <NSObject>
/**展示消息提示红点*/
-(void)showMsgTip;
/**隐藏消息提示红点*/
-(void)hidenMsgTip;

@end
@interface GYHDMessageViewController : GYBaseViewController
@property(nonatomic,weak)id<GYHDMessageViewControllerDelegate> delegate;
@end
