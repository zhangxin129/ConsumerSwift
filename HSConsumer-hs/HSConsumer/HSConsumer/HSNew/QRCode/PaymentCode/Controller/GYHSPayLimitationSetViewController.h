//
//  GYHSPayLimitationSetViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSTradingPasswordViewController.h"

@protocol GYHSSettingSuccessDategale <NSObject>
@optional
-(void)settingQuotasSuccess;

@end

@interface GYHSPayLimitationSetViewController : GYViewController
@property (nonatomic,assign)GYHSTradingPasswordType tradingPasswordType;

@property (nonatomic,weak)id<GYHSSettingSuccessDategale> successDategale;

@end
