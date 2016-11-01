//
//  GYHDRealNameWithLicenceAuthViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDLicenceAuthDelegate <NSObject>
@optional
- (void)licenceAuth:(NSMutableDictionary*)dictInside;
@end
@interface GYHDRealNameWithLicenceAuthViewController : GYViewController
@property (nonatomic,weak)id<GYHDLicenceAuthDelegate> licenceDelegate;
@end
