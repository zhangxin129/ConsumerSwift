//
//  GYCertificationTypeViewController.h
//  HSConsumer
//
//  Created by apple on 15-2-9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYCertificationType;
@protocol GYSenderTestDataDelegate <NSObject>

- (void)sendSelectDataWithMod:(GYCertificationType*)model;

@end

@interface GYCertificationTypeViewController : GYViewController
@property (nonatomic, weak) id<GYSenderTestDataDelegate> delegate;
@property (nonatomic, strong) NSMutableArray* marrDataSoure;

/**
 * 当前选择的证件行
 */
@property (nonatomic, assign) NSInteger selectIndex;

@end
