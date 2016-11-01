//
//  GYHDRightChatMapCell.h
//  HSConsumer
//
//  Created by shiang on 16/7/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDChatDelegate.h"
#import "GYHDChatModel.h"
#import "GYHDSessionRecordModel.h"
@interface GYHDRightChatMapCell : UITableViewCell
@property (nonatomic, weak) GYHDChatModel *model;
@property (nonatomic, weak) id<GYHDChatDelegate> delegate;
@property (nonatomic, strong)GYHDSessionRecordModel * sessionModel;
@end
