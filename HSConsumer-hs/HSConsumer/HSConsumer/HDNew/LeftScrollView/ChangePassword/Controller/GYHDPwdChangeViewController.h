//
//  GYHDPwdChangeViewController.h
//  HSConsumer
//
//  Created by kuser on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYViewController.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,GYHDChangePasswordType){
    
    GYHDLoginPasswordTypeModify = 0,   //修改登录密码
    GYHDTradingPasswordTypeModify = 1  //修改交易密码
};

@interface GYHDPwdChangeViewController : GYViewController

@property (nonatomic,assign)GYHDChangePasswordType changePasswordType;

@property (nonatomic,assign) NSInteger isFirstNumber;  //1：有交易密码修改 2：无交易密码修改


@end
