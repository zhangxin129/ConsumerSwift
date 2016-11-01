//
//  GYHDRealNameWithIdentifyAuthViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDIdentifyAuthDelegate <NSObject>
@optional
- (void)identifyAuth:(NSMutableDictionary*)dictInside;
@end
@interface GYHDRealNameWithIdentifyAuthViewController : GYViewController

@property(nonatomic,weak)id<GYHDIdentifyAuthDelegate> identifyDelegate;
@end
