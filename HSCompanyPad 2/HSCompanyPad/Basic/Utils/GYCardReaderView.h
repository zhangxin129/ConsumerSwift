//
//  GYShowBtDevicesVC.h
//  company
//
//  Created by liangzm on 15-4-18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYBaseViewController.h"
@class GYCardReaderView;
@class GYCardReaderModel;

@protocol GYShowBtDevicesVCDelegate <NSObject>
@optional
- (void)ShowBtDevicesVC:(GYCardReaderView*)ShowBtDevicesVC PosDevice:(GYCardReaderModel*)PosDevice;
- (void)ShowBtDevicesVC:(GYCardReaderView*)ShowBtDevicesVC cardNo:(NSString*)cardNo;
@end

@interface GYCardReaderView : UIView

@property (nonatomic, weak) id<GYShowBtDevicesVCDelegate> delegate;
@end
