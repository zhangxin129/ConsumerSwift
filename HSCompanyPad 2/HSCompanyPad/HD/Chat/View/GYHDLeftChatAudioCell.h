//
//  GYHDLeftChatAudioCell.h
//  HSConsumer
//
//  Created by shiang on 16/3/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDChatDelegate.h"
#import "GYHDChatModel.h"
#import "GYHDSessionRecordModel.h"

@interface GYHDLeftChatAudioCell : UITableViewCell
@property (nonatomic, weak) GYHDChatModel   *model;
@property (nonatomic, weak) id<GYHDChatDelegate> delegate;
@property (nonatomic, strong)GYHDSessionRecordModel * sessionModel;
- (void)startAudioAnimation;
- (void)stopAudioAnimation;
- (BOOL)isAudioAnimation;
@end
