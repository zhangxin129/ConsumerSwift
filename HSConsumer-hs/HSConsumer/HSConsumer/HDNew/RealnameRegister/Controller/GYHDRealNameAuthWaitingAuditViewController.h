//
//  GYHDRealNameAuthWaitingAuditViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDAgainAuthcenticationDelegate <NSObject>
@optional
- (void)againAuth;
@end
@interface GYHDRealNameAuthWaitingAuditViewController : GYViewController
//审核状态
@property (nonatomic,copy)NSString *reviewStatus;

//驳回原因
@property (nonatomic, copy) NSString *refuseReason;

@property (nonatomic,weak)id<GYHDAgainAuthcenticationDelegate> againAuthDelegate;
@end
