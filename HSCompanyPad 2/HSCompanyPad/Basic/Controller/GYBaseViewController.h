//
//  GYBaseViewController.h
//  HSCompanyPad
//
//  Created by User on 16/7/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GYStopType)
{
    GYStopTypeStopPointAct,//停止积分活动
    GYStopTypeLogout,//资格申请注销
    GYStopTypeAll, //全部
};

@class GYVCConfiguration;
@interface GYBaseViewController : UIViewController
@property (nonatomic, strong) GYVCConfiguration *configuration;
@property (nonatomic, assign) GYStopType type;
- (void)leftBtnAction;

+(UIViewController *)getCurrentVC;
- (void)initLoadingView;
- (void)loadInitViewType:(GYStopType)type :(void(^)(void))load;

@end
