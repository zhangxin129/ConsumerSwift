//
//  GYHDFriendDetailCell.h
//  HSConsumer
//
//  Created by shiang on 16/1/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDFriendDetailCellDelegate <NSObject>

- (void)cellDidEndEdit:(NSString *)string;

@end

@class GYHDFriendDetailModel;
@interface GYHDFriendDetailCell : UITableViewCell
@property (nonatomic, strong) GYHDFriendDetailModel* friendDetailModel;
@property(nonatomic, weak)id<GYHDFriendDetailCellDelegate> delegate;
@end
