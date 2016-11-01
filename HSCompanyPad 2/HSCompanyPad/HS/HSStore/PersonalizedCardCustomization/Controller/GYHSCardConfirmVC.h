//
//  GYHSCardConfirmVC.h
//
//  Created by apple on 16/8/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"

@class GYHSListSpecCardStyleModel;

typedef NS_ENUM(NSUInteger, GYHSCardLookStateType)
{
    GYHSCardLookStateTypeToConfirm,//待确认
    GYHSCardLookStateTypeConfirmed //已确认
};


@interface GYHSCardConfirmVC: GYBaseViewController

@property (nonatomic, assign) GYHSCardLookStateType type;
@property (nonatomic, strong) GYHSListSpecCardStyleModel *model;

@end
