//
//  GYHDAddFriendCell.h
//  HSConsumer
//
//  Created by shiang on 16/3/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "GYHDBaseCell.h"

@class GYHDAddFriendModel;
@class GYHDAddFriendCell;

@protocol GYHDAddFriendCellDelegate <NSObject>
- (void)GYHDAddFriendCell:(GYHDAddFriendCell*)cell model:(GYHDAddFriendModel*)model;
@end

@interface GYHDAddFriendCell : GYHDBaseCell
@property (nonatomic, strong) GYHDAddFriendModel* model;
@property (nonatomic, weak) id<GYHDAddFriendCellDelegate> delegate;
@end
