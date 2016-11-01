//
//  GYLinkQuickPayCardViewController.h
//  HSConsumer
//
//  Created by admin on 16/7/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYViewController.h"

@protocol GYLinkQuickPayCardDelegate <NSObject>

@optional
- (void)refreshDataWhenback;

@end

@interface GYLinkQuickPayCardViewController : GYViewController

@property (nonatomic, copy) NSString *bindBankUrl;
@property (nonatomic, copy) NSString *returnUrl;
@property (nonatomic, weak) id<GYLinkQuickPayCardDelegate> delegate;

@end
