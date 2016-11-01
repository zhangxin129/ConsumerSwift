//
//  GYHDRealNameWithPassportAuthViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDPassportAuthDelegate <NSObject>
@optional
- (void)passportAuth:(NSMutableDictionary*)dictInside;
@end
@interface GYHDRealNameWithPassportAuthViewController : GYViewController
@property (nonatomic,weak)id<GYHDPassportAuthDelegate> passportDelegate;
@end
