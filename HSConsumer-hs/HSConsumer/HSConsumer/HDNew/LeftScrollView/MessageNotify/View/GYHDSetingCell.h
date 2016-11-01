//
//  GYHDSetingCell.h
//  HSConsumer
//
//  Created by shiang on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDSetingGroupModel.h"

@class GYHDSetingCell;

@protocol GYHDSetingCellDelegate <NSObject>

- (void)swithClickWithCell:(GYHDSetingCell *)cell;

@end

@interface GYHDSetingCell : UITableViewCell

@property(nonatomic, strong)GYHDSetingModel *model;
@property(nonatomic, weak)id<GYHDSetingCellDelegate> delegate;

@end
