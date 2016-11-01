//
//  GYHDRealNameRegisterSuccessViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYHDContinueAuthenticationDelegate <NSObject>
@optional
- (void)ContinueAuthentication;
@end
@interface GYHDRealNameRegisterSuccessViewController : GYViewController
@property (nonatomic,weak)id<GYHDContinueAuthenticationDelegate> continueDelegate;
@end
