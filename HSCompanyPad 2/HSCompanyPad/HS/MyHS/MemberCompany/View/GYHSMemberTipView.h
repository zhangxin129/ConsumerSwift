//
//  GYHSMemberTipView.h
//
//  Created by apple on 16/8/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, kMyhsTipType) {
    kMyhsTipMemberCancel = 1,//成员企业资格注销
    kMyhsTipJoinPointActivity = 2,//参与积分活动
    kMyhsTipStopPointActivity = 3,//停止积分活动
};
@interface GYHSMemberTipView : UIView
- (instancetype)initWithFrame:(CGRect)frame tipType:(kMyhsTipType)tipType;
@end
                                                