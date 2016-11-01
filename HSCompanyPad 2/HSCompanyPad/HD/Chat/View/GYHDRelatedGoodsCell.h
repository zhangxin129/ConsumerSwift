//
//  GYHDRelatedGoodsCell.h
//  HSConsumer
//
//  Created by shiang on 16/7/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  关联商品

#import <UIKit/UIKit.h>
#import "GYHDChatModel.h"
#import "GYHDSessionRecordModel.h"
@interface GYHDRelatedGoodsCell : UITableViewCell

@property(nonatomic, strong)GYHDChatModel *model;
@property (nonatomic, strong)GYHDSessionRecordModel * sessionModel;
@end
