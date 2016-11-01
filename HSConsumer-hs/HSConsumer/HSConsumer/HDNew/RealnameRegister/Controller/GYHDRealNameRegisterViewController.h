//
//  GYHSRealNameRegisterViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDRegisterRightnowDelegate <NSObject>
@optional
- (void)RightnowRegister;
@end

@interface GYHDRealNameRegisterViewController : GYViewController

@property (nonatomic,weak)id<GYHDRegisterRightnowDelegate> rightnowDelegate;
@end
