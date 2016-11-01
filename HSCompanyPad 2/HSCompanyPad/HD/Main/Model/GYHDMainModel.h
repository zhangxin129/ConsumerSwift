//
//  GYHDLeftModel.h
//  HSCompanyPad
//
//  Created by shiang on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//  做左边主要类型

#import <Foundation/Foundation.h>

@interface GYHDMainModel : NSObject
/**顶部图片文字*/
@property(nonatomic, copy)NSString *topImageString;
/**顶部选中图片文字*/
@property(nonatomic, copy)NSString *topSelectImageString;
/**底部提示文字*/
@property(nonatomic, copy)NSString *bottomTitleString;
/**选中*/
@property(nonatomic, assign)BOOL select;
/**是否消息提示*/
@property(nonatomic,assign)BOOL msgTip;
@end
